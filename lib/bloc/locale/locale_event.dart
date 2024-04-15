import 'package:flutter/material.dart';

abstract class LocaleEvent {}

class ChangeLocaleEvent extends LocaleEvent {
  final Locale newLocale;

  ChangeLocaleEvent(this.newLocale);
}
