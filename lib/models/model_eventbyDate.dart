import 'package:opscheck/models/model_event.dart';

class EventByDate {
  final DateTime date;
  final List<Event> events;

  EventByDate({
    required this.date,
    required this.events,
  });

  factory EventByDate.fromJson(Map<String, dynamic> json) {
    final List<Event> events = [];
    if (json['events'] != null) {
      // Extract event data from JSON
      final List<dynamic> eventDataList = json['events'];
      events
          .addAll(eventDataList.map((eventData) => Event.fromJson(eventData)));
    }
    // Parse date string into DateTime object
    final DateTime date = DateTime.parse(json['date']);
    return EventByDate(
      date: date,
      events: events,
    );
  }
}
