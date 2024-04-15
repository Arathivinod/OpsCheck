import 'package:flutter/material.dart';

abstract class LocaleState {}

class LocaleInitial extends LocaleState {}

class LocaleChanged extends LocaleState {
  final Locale currentLocale;

  LocaleChanged(this.currentLocale);
}
