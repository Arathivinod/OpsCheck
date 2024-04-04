import 'package:flutter/material.dart';
import 'package:opscheck/models/analytics_data.dart';
import 'package:opscheck/services/analytics_service.dart';

class AnalyticsDataProvider extends ChangeNotifier {
  List<String>? _dates;
  List<double>? _officeCounts;
  List<double>? _wfhCounts;
  List<double>? _absentCounts;
  late String _selectedTimeRange;

  List<String>? get dates => _dates;
  List<double>? get officeCounts => _officeCounts;
  List<double>? get wfhCounts => _wfhCounts;
  List<double>? get absentCounts => _absentCounts;
  String get selectedTimeRange => _selectedTimeRange;

  set selectedTimeRange(String value) {
    _selectedTimeRange = value;
    notifyListeners();
  }

  Future<void> fetchData(String startDate, String endDate, int eventId) async {
    try {
      AnalyticsData data =
          await AnalyticsService.fetchData(startDate, endDate, eventId);
      _dates = data.dates;
      _officeCounts = data.officeCounts;
      _wfhCounts = data.wfhCounts;
      _absentCounts = data.absentCounts;
      notifyListeners();
    } catch (e) {
      print('Failed to load data: $e');
    }
  }
}
