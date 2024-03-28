import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:opscheck/models/model_eventresponse.dart';
import 'package:opscheck/models/model_eventbyDate.dart';

DateTime dateOnly(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

class EventService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1/analytics';

  static Future<List<EventByDate>> fetchEventsByDate(DateTime date) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=5000'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final eventResponse = EventResponse.fromJson(responseData);
      return eventResponse.eventsWithParticipantsByDate
          .where((eventByDate) =>
              _isSameDay(dateOnly(eventByDate.date), dateOnly(date)))
          .toList();
    } else {
      throw Exception(
          'Failed to fetch events. Status Code: ${response.statusCode}');
    }
  }
}
