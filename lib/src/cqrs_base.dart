
abstract class Command {
  /// Validates command before being submitted to the command bus.
  Exception validate() => null;
}

abstract class AggregateModel {
  String get id;
}

abstract class Aggregate<Model extends AggregateModel> {

}