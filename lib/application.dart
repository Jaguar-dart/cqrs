/// This library exposes interfaces to configure and build a CQRS
/// pipeline.

import 'dart:async';
import 'command_bus/command_bus.dart';
import 'repository/repository.dart';
import 'definition.dart';

export 'command_bus/command_bus.dart';
export 'repository/repository.dart';

class Cqrs {
  final _aggregates = <String, Aggregate>{};

  final _repos = <String, Repository>{};

  void registerAggregate(Aggregate aggregate) async {
    _aggregates[aggregate.name] = aggregate;
  }

  void registerAggregates(Iterable<Aggregate> aggregates) async {
    for (Aggregate aggregate in aggregates) {
      _aggregates[aggregate.name] = aggregate;
    }
  }

  void registerRepository(Repository repo) async {
    _repos[repo.forAggregate] = repo;
  }

  void registerRepositories(Iterable<Repository> repos) async {
    for (Repository repo in repos) {
      _repos[repo.forAggregate] = repo;
    }
  }

  // TODO support locking, callbacks, success status
  Future<void> submitCommand(Command command) async {
    final String aggregateName = command.forAggregate;

    final Aggregate agg = _aggregates[aggregateName];
    final Repository repo = _repos[aggregateName];

    if (agg == null) {
      throw Exception("Aggregate not found: ${aggregateName}.");
    }
    if (repo == null) {
      throw Exception("Repository not found for aggregate: ${aggregateName}.");
    }

    if (agg.modelType != repo.modelType) {
      throw Exception("Model types of aggregate and repository do not match!");
    }

    // TODO load from snapshot

    Stream<Event> foldEvents = await repo.fetchEventsById(command.modelId);
    final model = await agg.fold(foldEvents);

    List<Event> uncommittedEvents = await agg.handleCommand(command, model);
    await repo.saveEvents(command.modelId, uncommittedEvents);

    // TODO publish events
  }
}
