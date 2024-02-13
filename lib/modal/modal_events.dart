class Event {
  final String eventName;
  final String category;
  final String date;
  final String time;

  Event({
    required this.eventName,
    required this.category,
    required this.date,
    required this.time,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventName: json['eventName'],
      category: json['category'],
      date: json['date'],
      time: json['time'],
    );
  }
}
class EventResponse {
  final String status;
  final List<Event> events;

  EventResponse({
    required this.status,
    required this.events,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      status: json['status'],
      events: (json['data']['events'] as List)
          .map((eventJson) => Event.fromJson(eventJson))
          .toList(),
    );
  }
}
