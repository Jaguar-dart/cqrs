part of 'cqrs_example.dart';

class AccountRepo extends Repository<Account> {
  final _models = <String, List<Event>>{};

  @override
  String get forAggregate => "account";

  @override
  Stream<Event> fetchEventsById(String id) {
    List<Event> events = _models[id] ?? <Event>[];
    return Stream.fromIterable(events.toList(growable: false));
  }

  @override
  void saveEvents(String id, List<Event> newEvents) {
    // TODO lock?
    List<Event> events = _models[id];
    if (events == null) {
      _models[id] = newEvents.toList();
      return;
    }
    events.addAll(newEvents);
  }
}
