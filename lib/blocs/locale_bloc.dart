import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en'); // Default locale

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}
