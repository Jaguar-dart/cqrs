part of 'cqrs_example.dart';

class AccountCreatedEvent implements Event {
  String get forAggregate => "account";

  final String owner;

  AccountCreatedEvent({@required this.owner});
}

class DepositPerformedEvent implements Event {
  String get forAggregate => "account";

  final double amount;

  DepositPerformedEvent({@required this.amount});
}

class WithdrawalPerformedEvent implements Event {
  String get forAggregate => "account";

  final double amount;

  WithdrawalPerformedEvent({@required this.amount});
}