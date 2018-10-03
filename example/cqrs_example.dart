import 'dart:async';
import 'package:jaguar_cqrs/jaguar_cqrs.dart';
import 'package:meta/meta.dart';

part 'aggregate.dart';
part 'commands.dart';
part 'events.dart';
part 'model.dart';

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
