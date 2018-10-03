part of 'cqrs_example.dart';

class AccountCreatedEvent implements Event {
  String get forAggregate => "account";

  final String id;

  final String owner;

  AccountCreatedEvent({@required this.id, @required this.owner});

  String toString() => "Created account ($id) for $owner.";
}

class DepositPerformedEvent implements Event {
  String get forAggregate => "account";

  final String id;

  final double amount;

  DepositPerformedEvent({@required this.id, @required this.amount});

  String toString() => "Deposited $amount\$ into account $id.";
}

class WithdrawalPerformedEvent implements Event {
  String get forAggregate => "account";

  final String id;

  final double amount;

  WithdrawalPerformedEvent({@required this.id, @required this.amount});

  String toString() => "Withdrew $amount\$ from account $id.";
}
