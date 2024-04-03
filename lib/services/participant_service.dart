import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:opscheck/models/model_participant.dart';

class ParticipantService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1/analytics';

  static Future<Map<String, dynamic>> fetchParticipants(
      int eventId, DateTime eventDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
    final response =
        await http.get(Uri.parse('$baseUrl/$eventId?date=$formattedDate'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> participantsData =
          jsonData['data']['event']['participants'];

      final eventName = jsonData['data']['event']['eventName'];
      final category = jsonData['data']['event']['category'];

      final participants = participantsData
          .map((data) => Participant(
                participantId: data['participantId'],
                participantName: data['participantName'],
                participationMode: data['eventparticipantmapping']
                    ['participationMode'],
              ))
          .toList();
      participants
          .sort((a, b) => a.participantName.compareTo(b.participantName));

      return {
        'eventName': eventName,
        'category': category,
        'participants': participants,
      };
    } else {
      throw Exception('Failed to load participants');
    }
  }

  static Future<void> updateParticipationMode(
      int eventId, int participantId, int mode, DateTime date) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$eventId'),
        body: json.encode({
          'participantId': participantId,
          'participationMode': mode,
          'date': DateFormat('yyyy-MM-dd').format(date)
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update participation mode');
      }
    } catch (error) {
      print('Error updating participation mode: $error');
      throw error;
    }
  }
}
