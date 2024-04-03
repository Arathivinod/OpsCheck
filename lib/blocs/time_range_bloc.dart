// lib/blocs/time_range_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

enum TimeRange { day, thisWeek, thisMonth, custom }

class TimeRangeBloc extends Cubit<TimeRange> {
  TimeRangeBloc() : super(TimeRange.day);

  void setTimeRange(TimeRange timeRange) => emit(timeRange);
}
