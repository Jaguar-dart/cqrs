/// This library exposes interfaces that shall be implemented to define
/// a CQRS service.

import 'dart:async';

abstract class ForAggregate {
  /// The aggregate for which this services
  String get forAggregate;
}

abstract class AggregateModel {
  String get id;
}

/// Encapsulates a command in the CQRS system.
///
/// [modelId] specifies which domain model in aggregate this command operates on.
abstract class Command implements ForAggregate {
  String get modelId;

  /// Validates command before being submitted to the command bus.
  Exception validate() => null;
}

/// [Aggregate] represents an aggregate in CQRS system.
///
/// Use [handleCommand] method to submit a command to the aggregate for
/// processing.
abstract class Aggregate<Model extends AggregateModel> {
  String get name;

  Model initializeModel();

  Future<Model> fold(Stream<Event> events) async {
    final model = initializeModel();

    await for (Event event in events) {
      await apply(model, event);
    }

    return model;
  }

  /// Applies the modification [event] to [model]
  Future<void> apply(Model model, Event event);

  /// Handles command
  FutureOr<List<Event>> handleCommand(Command cmd, Model model);

  Type get modelType => Model;
}

abstract class Event implements ForAggregate {}
