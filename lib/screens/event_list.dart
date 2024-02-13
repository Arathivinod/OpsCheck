import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:opscheck/modal/modal_events.dart';
import 'package:intl/intl.dart';
import 'participant_list.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<Event> _events = [];
  List<Event> _newEvents = [];
  DateTime _selectedDate = DateTime.now(); // Initialize with current date
  // bool _isLoading = false;
  ValueNotifier<bool> _isLoading =
      ValueNotifier(false); // Flag to track whether events are being loaded

  @override
  void initState() {
    super.initState();
    _fetchEventsForSelectedDate(
        _selectedDate); // Fetch events for selected date
  }

  // Function to format the time
  String _formatTime(String time) {
    // Convert the time string to a DateTime object
    DateTime parsedTime = DateFormat('HH:mm').parse(time);

    // Format the DateTime object into AM/PM format
    String formattedTime = DateFormat('h:mm a').format(parsedTime);

    return formattedTime;
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<List<Event>> _fetchEventsForSelectedDate(DateTime selectedDate) async {
    print('Selected data: ' + selectedDate.toString());
    print('loaing');
    // setState(() {
    _isLoading.value =
        true; // Set loading flag to true when starting to fetch events
    // });
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/v1/events'));
      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        final events = parsedResponse['data']['events'] as List;

        _events = events
            .map((eventJson) => Event.fromJson(eventJson))
            .where((event) => DateTime.parse(event.date)
                .isAtSameMomentAs(dateOnly(_selectedDate)))
            .toList();
        print('Qaz' + _events.toString());
        _events.sort((a, b) => a.date.compareTo(b.date)); // Sort events by date
        _newEvents = _events;
        // Set loading flag to false after events are fetched

        print(_events);
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      print('Error fetching events: $error');
      // Handle error appropriately, e.g., show error message to user
    }
    // setState(() {
    _isLoading.value = false;
    // });
    return _newEvents;
    // setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    print(picked);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchEventsForSelectedDate(
          _selectedDate); // Fetch events for newly selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_events);
    return ValueListenableBuilder(
        valueListenable: _isLoading,
        builder: (BuildContext context, bool isLoading, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Event List',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blue, // Adding color to AppBar
            ),
            body: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Display progress indicator while loading events
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            ' ${DateFormat('dd-MM-yyyy').format(_selectedDate)}  ${DateFormat('EEEE').format(_selectedDate)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _newEvents.isEmpty
                            ? Center(child: Text('No events for selected date'))
                            : ListView.builder(
                                itemCount: _newEvents.length,
                                itemBuilder: (context, index) {
                                  final event = _newEvents[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ParticipantListScreen()),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 203, 227, 247),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                            '${event.eventName} - ${event.category}'),
                                        subtitle: Text(
                                            'Time: ${_formatTime(event.time)}'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          );
        });
  }
}
