import 'dart:async';
import 'package:jaguar_cqrs/jaguar_cqrs.dart';
import 'package:meta/meta.dart';

part 'aggregate.dart';
part 'commands.dart';
part 'events.dart';
part 'model.dart';
part 'repo.dart';

main() async {
  final cqrs = Cqrs()
    ..registerAggregate(AccountAggregate())
    ..registerRepository(AccountRepo());

  await cqrs.submitCommand(CreateAccountCmd(owner: "Teja", modelId: "1"));

  // TODO
}
