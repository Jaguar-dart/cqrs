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

  Future<Model> fold(Stream<DomainEvent> events) async {
    final model = initializeModel();

    await for (DomainEvent event in events) {
      await apply(model, event);
    }

    return model;
  }

  /// Applies the modification [event] to [model]
  Future<void> apply(Model model, DomainEvent event);

  /// Handles command
  FutureOr<void> handleCommand(Command cmd, Model model, CommandOutput out);

  Type get modelType => Model;
}

class CommandResult {
  final dynamic result;

  final dynamic error;

  const CommandResult({this.result, this.error});

  bool get isSuccess => error == null;
}

class CommandOutput {
  final _events = <AnyEvent>[];

  dynamic _result;

  dynamic _error;

  void addEvent(AnyEvent event) {
    _events.add(event);
  }

  void addEvents(Iterable<AnyEvent> event) {
    _events.addAll(event);
  }

  void setResult(dynamic value) {
    _result = value;
  }

  void setError(dynamic value) {
    _error = value;
  }

  Iterable<AnyEvent> getEvents() => _events;

  T getResult<T>() {
    return _result as T;
  }

  T getError<T>() {
    return _error as T;
  }
}

/// Events that shall be emitted by Aggregate as a result of executing a command.
abstract class AnyEvent implements ForAggregate {}

/// Events that will be persisted in EventStore and will potentially be used by
/// Aggregate to build up the state.
abstract class DomainEvent implements AnyEvent, ForAggregate {}

/// NotificationEvent are not persisted in the EventStore. Their sole purpose is
/// to notify other services.
abstract class NotificationEvent implements AnyEvent, ForAggregate {}

abstract class Event implements DomainEvent, NotificationEvent {}
