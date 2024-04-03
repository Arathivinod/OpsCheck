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
