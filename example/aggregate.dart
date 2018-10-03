part of 'cqrs_example.dart';

class AccountAggregate extends Aggregate<Account> {
  final String name = 'account';

  @override
  Account initializeModel() => Account();

  @override
  Future<void> apply(Account model, DomainEvent event) async {
    if (event is AccountCreatedEvent) {
      model.id = event.id;
      model.owner = event.owner;
      model.amount = 0.0;
    } else if (event is DepositPerformedEvent) {
      model.amount += event.amount;
    } else if (event is WithdrawalPerformedEvent) {
      model.amount -= event.amount;
    } else {
      throw Exception("Unknown event!");
    }
  }

  @override
  Future<void> handleCommand(
      Command cmd, Account model, CommandOutput out) async {
    if (cmd is CreateAccountCmd) {
      if (model.id != null) {
        out.setError("Model with id ${cmd.modelId} already exists!");
        return;
      }
      out.addEvent(AccountCreatedEvent(id: cmd.modelId, owner: cmd.owner));
    } else if (cmd is DepositCmd) {
      out.addEvent(DepositPerformedEvent(id: cmd.modelId, amount: cmd.amount));
    } else if (cmd is WithdrawCmd) {
      if (model.amount < cmd.amount) {
        out.setError("Not enough balance!");
        return;
      }
      out.addEvent(
          WithdrawalPerformedEvent(id: cmd.modelId, amount: cmd.amount));
      return;
    } else {
      throw UnsupportedError(cmd.runtimeType.toString());
    }
  }
}
