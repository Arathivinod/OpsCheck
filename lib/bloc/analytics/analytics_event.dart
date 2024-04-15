// analytics_event.dart

import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object> get props => [];
}

class FetchAnalyticsData extends AnalyticsEvent {
  final String startDate;
  final String endDate;
  final int eventId;

  FetchAnalyticsData({
    required this.startDate,
    required this.endDate,
    required this.eventId,
  });

  @override
  List<Object> get props => [startDate, endDate, eventId];
}
