import 'package:opscheck/models/model_participant.dart';

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

  factory Event.fromJson(Map<String, dynamic> json) {
    // Extract participant data from JSON
    final List<dynamic> participantDataList = json['participants'];
    final List<Participant> participants = participantDataList
        .map((participantData) => Participant.fromJson(participantData))
        .toList();
    return Event(
      eventId: json['eventId'],
      eventName: json['eventName'],
      time: json['time'],
      category: json['category'],
      participants: participants,
    );
  }
}
