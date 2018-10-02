part of 'cqrs_example.dart';

class Account implements AggregateModel {
  String id;

  String owner;

  double amount;

  Account({this.id, this.owner, this.amount});
}
