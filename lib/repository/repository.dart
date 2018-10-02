import 'dart:async';
import 'package:jaguar_cqrs/definition.dart';

/// [Repository] represents a repository in CQRS system.
///
/// A [Repository] works for a particular aggregate and fetches data from the
/// underlying data store.
/// Use [fetchById] to fetch a domain model by id.
abstract class Repository<Model extends AggregateModel>
    implements ForAggregate<Model> {
  /// Fetches model by [id]
  Future<Model> fetchModificationEventsById(String id);

  /// Fetches model by [id]
  Future<Model> saveModificationEventsById(String id);
}
