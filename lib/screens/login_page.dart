import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:opscheck/providers/locale_provider.dart';
import 'event_list.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildLanguageDropdownButton(context),
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

  Widget _buildLanguageDropdownButton(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return DropdownButton<String>(
          value: localeProvider.currentLocale.languageCode,
          onChanged: (languageCode) {
            if (languageCode != null) {
              localeProvider.changeLocale(Locale(languageCode));
            }
          },
          items: AppLocalizations.supportedLocales
              .map(
                (locale) => DropdownMenuItem<String>(
                  value: locale.languageCode,
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
