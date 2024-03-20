import 'package:opscheck/models/model_eventbyDate.dart';

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
