# CQRS/ES

Command Query Responsibility Separation and Event Sourcing library for
Dart.

# Usage

## Define Domain model

```
class Account implements AggregateModel {
  String id;

  String owner;

  double amount;

  Account({this.id, this.owner, this.amount});
}
```

## Define commands

```
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
```

## Define events

```
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
```

## Define aggregate

```
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
```

## Glue them all together

```
main() async {
  final cqrs = Cqrs()
    ..registerAggregate(AccountAggregate())
    ..registerRepository(InMemoryRepository<Account>(forAggregate: "account"));

  cqrs.events.listen(print);

  await cqrs.submitCommand(CreateAccountCmd(owner: "Teja", modelId: "1"));
  await cqrs.submitCommand(DepositCmd(modelId: "1", amount: 200.0));
  await cqrs.submitCommand(DepositCmd(modelId: "1", amount: 200.0));
  await cqrs.submitCommand(WithdrawCmd(modelId: "1", amount: 300.0));
  await cqrs.submitCommand(DepositCmd(modelId: "1", amount: 400.0));
}
```

Outputs.

> Created account (1) for Teja.
> Deposited 200.0$ into account 1.
> Deposited 200.0$ into account 1.
> Withdrew 300.0$ from account 1.
> Deposited 400.0$ into account 1.