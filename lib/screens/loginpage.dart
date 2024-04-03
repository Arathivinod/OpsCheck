import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'event_list.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) changeLocale;

  const LoginScreen({Key? key, required this.changeLocale}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String? employeeId;
  late String? password;
  String _selectedLanguage = 'en'; // Default language code is 'en'

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
          key: _formKey,
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
                onSaved: (value) => employeeId = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  border: OutlineInputBorder(),
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
                onSaved: (value) => password = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EventListScreen()),
                      (route) => false,
                    );
                  }
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
    return DropdownButton<String>(
      value: _selectedLanguage,
      onChanged: (languageCode) {
        if (languageCode != null) {
          setState(() {
            _selectedLanguage = languageCode;
          });
          widget.changeLocale(Locale(languageCode));
        }
      },
      items: AppLocalizations.supportedLocales
          .map(
            (locale) => DropdownMenuItem<String>(
              value: locale.languageCode,
              child: Text(
                locale.languageCode.toUpperCase(),
                style:
                    TextStyle(color: Colors.black), // Set font color to black
              ),
            ),
          )
          .toList(),
    );
  }
}
