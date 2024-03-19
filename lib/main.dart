import 'package:flutter/material.dart';
import 'package:opscheck/screens/loginpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale("en"),
      title: 'OpsCheck',
      home: const LoginScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          // Text style for the app bar title
          backgroundColor: Colors.blue, // Background color of the app bar
          iconTheme:
              IconThemeData(color: Colors.white), // Icon color of the app bar
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Example color
          ),
          titleMedium: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey, // Example color
          ),

          // You can define other text styles as well such as headline1, headline2, subtitle1, etc.
        ),
        // Define other theme properties for your app here
      ),
    );
  }
}
