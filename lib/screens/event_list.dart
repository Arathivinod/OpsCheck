import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:opscheck/modal/modal.dart'; // Importing Event model
import 'participant_list.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late List<EventByDate> _eventsByDate = [];
  late DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEventsByDate(_selectedDate);
    print("Current Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}");
  }

  DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _fetchEventsByDate(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/v1/analytics?limit=5000'));

      print('API Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final eventResponse = EventResponse.fromJson(responseData);

        setState(() {
          _eventsByDate = eventResponse.eventsWithParticipantsByDate
              .where((eventByDate) =>
                  _isSameDay(dateOnly(eventByDate.date), dateOnly(date)))
              .toList();
          _isLoading = false;
        });

        print("Filtered events: $_eventsByDate");
        print("Selected Date: $date");
      } else {
        throw Exception(
            'Failed to fetch events. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching events: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      await _fetchEventsByDate(_selectedDate);
      print("Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}");
    }
  }

  void _nextDate() async {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
    await _fetchEventsByDate(_selectedDate);
  }

  void _previousDate() async {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
    await _fetchEventsByDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // App bar color
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousDate,
                        icon: Icon(Icons.arrow_back),
                        color: Colors.blue,
                      ),
                      ElevatedButton(
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          elevation: MaterialStateProperty.all(
                              0.0), // Remove elevation
                        ),
                      ),
                      IconButton(
                        onPressed: _nextDate,
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _eventsByDate.isEmpty
                      ? Center(
                          child: Text('No events for selected date'),
                        )
                      : ListView.builder(
                          itemCount: _eventsByDate.length,
                          itemBuilder: (context, index) {
                            final eventByDate = _eventsByDate[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: eventByDate.events.length,
                                  itemBuilder: (context, index) {
                                    final event = eventByDate.events[index];
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey, // Border color
                                          // Border width
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                            '${event.eventName} - ${event.category}'),
                                        subtitle: Text(
                                          'Time: ${_formatTime(event.time)}',
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ParticipantListScreen(
                                                eventId: event.eventId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  String _formatTime(String time) {
    // Convert the time string to a DateTime object
    DateTime parsedTime = DateFormat('HH:mm').parse(time);

    // Format the DateTime object into AM/PM format
    String formattedTime = DateFormat('h:mm a').format(parsedTime);

    return formattedTime;
  }
}
