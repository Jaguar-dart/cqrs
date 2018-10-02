part of 'cqrs_example.dart';

class Account implements AggregateModel {
  String id;

  int amount;

  Account({this.id, this.amount});
}