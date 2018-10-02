/// This library exposes interfaces that shall be implemented to define
/// a CQRS service.

import 'dart:async';

abstract class ForAggregate<Model extends AggregateModel> {
  /// The aggregate for which this services
  String get forAggregate;
}

abstract class AggregateModel {
  String get id;
}

/// Encapsulates a command in the CQRS system.
///
/// [modelId] specifies which domain model in aggregate this command operates on.
abstract class Command<Model extends AggregateModel>
    implements ForAggregate<Model> {
  String get modelId;

  /// Validates command before being submitted to the command bus.
  Exception validate() => null;
}

/// [Aggregate] represents an aggregate in CQRS system.
///
/// Use [handleCommand] method to submit a command to the aggregate for
/// processing.
abstract class Aggregate<Model extends AggregateModel> {
  /// Applies the modification [event] to [model]
  Future<void> apply(Model model, Event<Model> event);

  /// Handles command
  Future<List<Event>> handleCommand(Command<Model> cmd, Model model);
}

abstract class Event<Model extends AggregateModel> implements ForAggregate {}
