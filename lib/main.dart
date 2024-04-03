import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:opscheck/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:opscheck/models/locale_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(), // Provide LocaleProvider
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeProvider.currentLocale, // Use current locale
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
                bodyLarge: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                titleMedium: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
