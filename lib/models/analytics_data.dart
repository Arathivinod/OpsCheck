// analytics_data.dart

class AnalyticsData {
  final List<String> dates;
  final List<double> officeCounts;
  final List<double> wfhCounts;
  final List<double> absentCounts;

  AnalyticsData({
    required this.dates,
    required this.officeCounts,
    required this.wfhCounts,
    required this.absentCounts,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      dates: List<String>.from(json['dates']),
      officeCounts:
          List<double>.from(json['officeCounts'].map((x) => x.toDouble())),
      wfhCounts: List<double>.from(json['wfhCounts'].map((x) => x.toDouble())),
      absentCounts:
          List<double>.from(json['absentCounts'].map((x) => x.toDouble())),
    );
  }
  factory AnalyticsData.empty() {
    return AnalyticsData(
      dates: [],
      officeCounts: [],
      wfhCounts: [],
      absentCounts: [],
    );
  }
}
