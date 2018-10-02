part of 'cqrs_example.dart';

class AccountAggregate extends Aggregate<Account> {
  final String name = 'account';

  @override
  Account initializeModel() => Account();

  @override
  Future<void> apply(Account model, Event event) async {
    // TODO
  }

  @override
  Future<List<Event>> handleCommand(Command cmd, Account model) async {
    final events = <Event>[];
    if (cmd is CreateAccountCmd) {
      if(model != null) {
        // TODO
      }
      return events;
    } else if (cmd is DepositCmd) {
      // TODO deposit event

      return events;
    } else if (cmd is WithdrawCmd) {
      // TODO withdraw event
      return events;
    } else {
      throw UnsupportedError(cmd.runtimeType.toString());
    }
  }
}
