import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:opscheck/bloc/analytics/analytics_state.dart';
import 'package:opscheck/screens/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opscheck/bloc/analytics/analytics_bloc.dart';
import 'package:opscheck/bloc/locale/locale_bloc.dart';
import 'package:opscheck/bloc/locale/locale_state.dart';
import 'package:opscheck/services/analytics_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider instead of MultiProvider
      providers: [
        BlocProvider<LocaleBloc>(
          // Provide LocaleBloc
          create: (_) => LocaleBloc(),
        ),
        BlocProvider<AnalyticsBloc>(
          // Provide AnalyticsBloc
          create: (_) => AnalyticsBloc(AnalyticsService()),
        ),
      ],
      child:
          BlocBuilder<LocaleBloc, LocaleState>(builder: (context, localeState) {
        return BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, analyticsState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: (localeState is LocaleChanged)
                  ? localeState.currentLocale
                  : const Locale('en'),
              title: AppLocalizations.of(context)?.title ?? 'Opscheck',
              home: LoginScreen(),
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  backgroundColor: Colors.blue,
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                textTheme: const TextTheme(
                  bodyText1: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  headline6: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
