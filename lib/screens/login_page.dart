import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:opscheck/blocs/locale_bloc.dart';
import 'event_list.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeBloc = BlocProvider.of<LocaleBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildLanguageDropdownButton(context, localeBloc),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.title,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.empid,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Employee ID';
                  }
                  if (value.length > 4) {
                    return 'Employee ID must not exceed 4 digits';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Employee ID must be a number';
                  }
                  return null;
                },
                onSaved: (value) {}, // Handle the saved value as needed
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 4) {
                    return 'Password must be at least 4 characters long';
                  }
                  return null;
                },
                onSaved: (value) {}, // Handle the saved value as needed
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle login button press
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EventListScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.login),
                label: Text(AppLocalizations.of(context)!.login),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdownButton(
      BuildContext context, LocaleBloc localeBloc) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return DropdownButton<Locale>(
          value: (state is LocaleChanged) ? state.currentLocale : null,
          onChanged: (newLocale) {
            if (newLocale != null) {
              localeBloc.add(ChangeLocaleEvent(newLocale));
            }
          },
          items: AppLocalizations.supportedLocales
              .map(
                (locale) => DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                    locale.languageCode.toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
