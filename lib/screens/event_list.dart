import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:opscheck/modal/modal.dart';
import 'participant_list.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<EventListScreen> {
  late List<EventByDate> _eventsByDate = [];
  late DateTime _selectedDate = DateTime.now();
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);
  final DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();
    _fetchEventsByDate(_selectedDate);
  }

  DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _fetchEventsByDate(DateTime date) async {
    _isLoadingNotifier.value = true;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/v1/analytics?limit=5000'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final eventResponse = EventResponse.fromJson(responseData);

        setState(() {
          _eventsByDate = eventResponse.eventsWithParticipantsByDate
              .where((eventByDate) =>
                  _isSameDay(dateOnly(eventByDate.date), dateOnly(date)))
              .toList();
        });
      } else {
        throw Exception(
            'Failed to fetch events. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error fetching events: $error');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Open date picker dialog here
                    showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(
                          Duration(days: 3)), // 3 days before the current date
                      lastDate: DateTime.now().add(
                          Duration(days: 7)), // 7 days from the current date
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                        _fetchEventsByDate(_selectedDate);
                        _controller
                            .animateToSelection(); // Update the timeline to reflect the selected date
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Select Date ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: DatePicker(
                      DateTime.now().subtract(Duration(days: 3)),
                      controller: _controller,
                      initialSelectedDate: _selectedDate,
                      selectionColor: Colors.blue,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) async {
                        setState(() {
                          _selectedDate = date;
                        });
                        await _fetchEventsByDate(_selectedDate);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLoadingNotifier,
              builder: (context, isLoading, child) {
                if (isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: _eventsByDate.isEmpty
                        ? [
                            Center(
                              child: Text('No events for selected date'),
                            ),
                          ]
                        : _eventsByDate
                            .expand(
                              (eventByDate) => eventByDate.events.map(
                                (event) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        243,
                                        249,
                                        255,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${event.eventName} - ${event.category}',
                                      ),
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
                                              eventDate: _selectedDate,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    DateTime parsedTime = DateFormat('HH:mm').parse(time);
    String formattedTime = DateFormat('h:mm a').format(parsedTime);
    return formattedTime;
  }
}
