import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opscheck/bloc/analytics/analytics_event.dart';
import 'package:opscheck/bloc/analytics/analytics_state.dart';
import 'package:opscheck/services/analytics_service.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsService analyticsService;

  AnalyticsBloc(this.analyticsService) : super(AnalyticsInitial());

  @override
  Stream<AnalyticsState> mapEventToState(AnalyticsEvent event) async* {
    if (event is FetchAnalyticsData) {
      yield AnalyticsLoading();
      try {
        final analyticsData = await AnalyticsService.fetchData(
          // Update this line
          event.startDate,
          event.endDate,
          event.eventId,
        );
        yield AnalyticsLoaded(analyticsData);
      } catch (e) {
        yield AnalyticsError(e.toString());
      }
    }
  }
}
