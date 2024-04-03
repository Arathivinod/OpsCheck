// lib/blocs/analytics_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opscheck/models/analytics_data.dart';
import 'package:opscheck/services/analytics_service.dart';

class AnalyticsState {
  final AnalyticsData? data;
  final bool isLoading;
  final String? error;

  AnalyticsState({this.data, this.isLoading = false, this.error});

  AnalyticsState copyWith({AnalyticsData? data, bool? isLoading, String? error}) {
    return AnalyticsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

abstract class AnalyticsEvent {}

class FetchAnalyticsData extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int eventId;

  FetchAnalyticsData(this.startDate, this.endDate, this.eventId);
}

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(AnalyticsState());

  @override
  Stream<AnalyticsState> mapEventToState(AnalyticsEvent event) async* {
    if (event is FetchAnalyticsData) {
      yield state.copyWith(isLoading: true);
      try {
        final data = await AnalyticsService.fetchData(
            event.startDate.toString(), event.endDate.toString(), event.eventId);
        yield state.copyWith(data: data, isLoading: false);
      } catch (e) {
        yield state.copyWith(error: 'Failed to load data: $e', isLoading: false);
      }
    }
  }
}
