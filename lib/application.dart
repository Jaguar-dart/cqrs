/// This library exposes interfaces to configure and build a CQRS
/// pipeline.

import 'dart:async';
import 'repository/repository.dart';
import 'definition.dart';

export 'repository/repository.dart';

/// Encapsulates and exposes a CQRS pipeline.
abstract class Cqrs {
  factory Cqrs() => _CqrsImpl();

  /// Stream of [NotificationEvent] emitted by the composing aggregates of this
  /// CQRS pipeline.
  Stream<NotificationEvent> get events;

  /// Registers the provided [aggregate].
  void registerAggregate(Aggregate aggregate);

  /// Registers all the provided [aggregates].
  void registerAggregates(Iterable<Aggregate> aggregates);

  /// Registers the provided [repository].
  void registerRepository(Repository repository);

  /// Registers the provided [repositories].
  void registerRepositories(Iterable<Repository> repositories);

  /// Submits the given [command] to the CQRS pipeline.
  Future<CommandResult> submitCommand(Command command);
}

class _CqrsImpl implements Cqrs {
  final _aggregates = <String, Aggregate>{};

  final _repos = <String, Repository>{};

  final _eventController = StreamController<NotificationEvent>();

  Stream<NotificationEvent> get events =>
      _eventController.stream.asBroadcastStream();

  void registerAggregate(Aggregate aggregate) {
    _aggregates[aggregate.name] = aggregate;
  }

  void registerAggregates(Iterable<Aggregate> aggregates) {
    for (Aggregate aggregate in aggregates) {
      _aggregates[aggregate.name] = aggregate;
    }
  }

  void registerRepository(Repository repo) {
    _repos[repo.forAggregate] = repo;
  }

  void registerRepositories(Iterable<Repository> repos) {
    for (Repository repo in repos) {
      _repos[repo.forAggregate] = repo;
    }
  }

  // TODO support locking by modelId
  Future<CommandResult> submitCommand(Command command) async {
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

    Stream<DomainEvent> foldEvents =
        await repo.fetchEventsById(command.modelId);
    final model = await agg.fold(foldEvents);

    final output = CommandOutput();
    await agg.handleCommand(command, model, output);
    await repo.saveEvents(command.modelId,
        output.getEvents().where((e) => e is DomainEvent).cast<DomainEvent>());

    Future.microtask(() {
      for (NotificationEvent e in output
          .getEvents()
          .where((e) => e is NotificationEvent)
          .cast<NotificationEvent>()) {
        _eventController.add(e);
      }
    });

    return CommandResult(result: output.getResult(), error: output.getError());
  }
}
