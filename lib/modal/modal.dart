class EventResponse {
  final List<EventByDate> eventsWithParticipantsByDate;

  EventResponse({
    required this.eventsWithParticipantsByDate,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    final List<EventByDate> eventsByDate = [];
    if (json['data'] != null &&
        json['data']['eventsWithParticipantsByDate'] != null) {
      final List<dynamic> eventDataList =
          json['data']['eventsWithParticipantsByDate'];
      eventsByDate.addAll(
          eventDataList.map((eventData) => EventByDate.fromJson(eventData)));
    }
    return EventResponse(
      eventsWithParticipantsByDate: eventsByDate,
    );
  }
}

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
      final Map<String, dynamic> eventData = json['events'];
      eventData.forEach((key, value) {
        events.add(Event.fromJson(int.parse(key), value));
      });
    }
    // Parse date string into DateTime object
    final DateTime date = DateTime.parse(json['date']);
    return EventByDate(
      date: date,
      events: events,
    );
  }
}

class Event {
  final int eventId;
  final String eventName;
  final String time;
  final String category;
  final List<Participant> participants;

  Event({
    required this.eventId,
    required this.eventName,
    required this.time,
    required this.category,
    required this.participants,
  });

  factory Event.fromJson(int eventId, Map<String, dynamic> json) {
    // Extract participant data from JSON
    final List<dynamic> participantDataList = json['participants'];
    final List<Participant> participants = participantDataList
        .map((participantData) => Participant.fromJson(participantData))
        .toList();
    return Event(
      eventId: eventId,
      eventName: json['eventName'],
      time: json['time'],
      category: json['category'],
      participants: participants,
    );
  }
}

class Participant {
  final int participantId;
  final String participantName;
  int participationMode;

  Participant({
    required this.participantId,
    required this.participantName,
    required this.participationMode,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      participantId: json['participantId'],
      participantName: json['participantName'],
      participationMode: json['participationMode'],
    );
  }
}
