import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opscheck/bloc/locale/locale_event.dart';
import 'package:opscheck/bloc/locale/locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInitial());

  @override
  Stream<LocaleState> mapEventToState(LocaleEvent event) async* {
    if (event is ChangeLocaleEvent) {
      yield* _mapChangeLocaleEventToState(event);
    }
  }

  Stream<LocaleState> _mapChangeLocaleEventToState(
    ChangeLocaleEvent event,
  ) async* {
    yield LocaleChanged(event.newLocale);
  }
}
