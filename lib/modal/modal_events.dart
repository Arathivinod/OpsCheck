// Model class representing an Event
class Event {
  final String eventName; // Name of the event
  final String category; // Category of the event
  final String date; // Date of the event
  final String time; // Time of the event

  Event({
    required this.eventName,
    required this.category,
    required this.date,
    required this.time,
  });

  // Factory method to create an Event object from JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventName: json['eventName'], // Extract eventName from JSON
      category: json['category'], // Extract category from JSON
      date: json['date'], // Extract date from JSON
      time: json['time'], // Extract time from JSON
    );
  }
}

// Model class representing a response containing a list of events
class EventResponse {
  final String status; // Status of the response
  final List<Event> events; // List of events in the response

  EventResponse({
    required this.status,
    required this.events,
  });

  // Factory method to create an EventResponse object from JSON data
  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      status: json['status'], // Extract status from JSON
      events: (json['data']['events'] as List) // Extract events list from JSON
          .map((eventJson) =>
              Event.fromJson(eventJson)) // Map JSON to Event objects
          .toList(), // Convert to a list of Event objects
    );
  }
}
