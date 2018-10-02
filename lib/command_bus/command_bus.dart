import 'dart:async';
import 'package:jaguar_cqrs/definition.dart';

/// [CommandBus] is responsible for receiving [CommandBus] from the API gateway
/// or client and forwarding them to corresponding [Aggregate].
///
abstract class CommandBus {
  void submitCommand(Command command);
}
