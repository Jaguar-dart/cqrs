import 'dart:async';
import 'package:meta/meta.dart';
import 'package:jaguar_cqrs/definition.dart';

/// [Repository] represents a repository in CQRS system.
///
/// A [Repository] works for a particular aggregate and fetches data from the
/// underlying data store.
/// Use [fetchById] to fetch a domain model by id.
abstract class Repository<Model extends AggregateModel>
    implements ForAggregate {
  /// Fetches model by [id]
  FutureOr<Stream<DomainEvent>> fetchEventsById(String id);

  /// Fetches model by [id]
  FutureOr<void> saveEvents(String id, Iterable<DomainEvent> events);

  Type get modelType => Model;
}

class InMemoryRepository<Model extends AggregateModel>
    extends Repository<Model> {
  final _models = <String, List<DomainEvent>>{};

  final String forAggregate;

  InMemoryRepository({@required this.forAggregate});

  @override
  Stream<DomainEvent> fetchEventsById(String id) {
    List<DomainEvent> events = _models[id] ?? <DomainEvent>[];
    return Stream.fromIterable(events.toList(growable: false));
  }

  @override
  void saveEvents(String id, Iterable<DomainEvent> newEvents) {
    // TODO lock?
    List<AnyEvent> events = _models[id];
    if (events == null) {
      _models[id] = newEvents.toList();
      return;
    }
    events.addAll(newEvents);
  }
}
