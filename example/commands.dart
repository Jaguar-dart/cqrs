part of 'cqrs_example.dart';

class CreateAccountCmd extends Command {
  final String owner;

  CreateAccountCmd({@required this.owner});
}

class DepositCmd extends Command {
  final int amount;

  DepositCmd({@required this.amount});
}

class WithdrawCmd extends Command {
  final int amount;

  WithdrawCmd({@required this.amount});
}