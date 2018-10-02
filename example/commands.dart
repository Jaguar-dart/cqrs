part of 'cqrs_example.dart';

abstract class ForAccount {
  final String forAggregate = "account";
}

class CreateAccountCmd extends Command with ForAccount {
  final String modelId;

  final String owner;

  CreateAccountCmd({@required this.owner, @required this.modelId});
}

class DepositCmd extends Command with ForAccount {
  final String modelId;

  final double amount;

  DepositCmd({@required this.amount, @required this.modelId});
}

class WithdrawCmd extends Command with ForAccount {
  final String modelId;

  final double amount;

  WithdrawCmd({@required this.amount, @required this.modelId});
}
