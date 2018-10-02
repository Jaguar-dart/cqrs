part of 'cqrs_example.dart';

class AccountAggregate implements Aggregate<Account> {
  @override
  Future<void> apply(Account model, Event<Account> event) async {
    // TODO
  }

  @override
  Future<List<Event>> handleCommand(Command<Account> cmd, Account model) async {
    if (cmd is CreateAccountCmd) {
      // TODO
    } else if (cmd is DepositCmd) {
      // TODO
    } else if (cmd is WithdrawCmd) {
      // TODO
    } else {
      // TODO
    }
  }
}
