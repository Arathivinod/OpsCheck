// analytics_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opscheck/services/event_service.dart';
import 'package:opscheck/models/analytics_data.dart'; // Replace 'your_project_name' with your actual project name

class AnalyticsService {
  static const baseUrl = EventService.baseUrl;

  static Future<AnalyticsData> fetchData(
      String startDate, String endDate, int eventId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/?limit=2000&startDate=$startDate&endDate=$endDate&filterBy=eventId&filterValue=$eventId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final eventsByDate = jsonData['data']['eventsWithParticipantsByDate'];

      List<String> dates = [];
      List<double> officeCounts = [];
      List<double> wfhCounts = [];
      List<double> absentCounts = [];

      eventsByDate.forEach((dayData) {
        final date = dayData['date'];
        final events = dayData['events'];

        double officeCount = 0;
        double wfhCount = 0;
        double absentCount = 0;

        events.forEach((eventDetails) {
          final participants = eventDetails['participants'];

          participants.forEach((participant) {
            final mode = participant['participationMode'];
            if (mode == 1) {
              officeCount++;
            } else if (mode == 2) {
              wfhCount++;
            } else if (mode == 3) {
              absentCount++;
            }
          });
        });

        dates.add(date);
        officeCounts.add(officeCount);
        wfhCounts.add(wfhCount);
        absentCounts.add(absentCount);
      });

      return AnalyticsData(
        dates: dates,
        officeCounts: officeCounts,
        wfhCounts: wfhCounts,
        absentCounts: absentCounts,
      );
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
