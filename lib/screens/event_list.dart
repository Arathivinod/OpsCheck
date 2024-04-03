import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opscheck/models/model_eventbyDate.dart';
import 'package:opscheck/services/event_service.dart';
import 'participant_list.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      // Fetch events for the current date
      List<EventByDate> events =
          await EventService.fetchEventsByDate(DateTime.now());

      // Update the state with the fetched events
      setState(() {
        _eventsByDate = events;
        _isLoadingNotifier.value = false;
      });
    } catch (e) {
      // Handle any errors that occurred during the fetch operation
      print('Error fetching events: $e');
      // Optionally, you can also set _isLoadingNotifier to false here if you want to handle errors
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
        title: Text(AppLocalizations.of(context)!.events),
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
                  onTap: () async {
                    // Open date picker dialog here
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(
                          days: 3)), // 3 days before the current date
                      lastDate: DateTime.now().add(const Duration(
                          days: 7)), // 7 days from the current date
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                      _fetchEventsByDate(_selectedDate);
                      _controller
                          .animateToSelection(); // Update the timeline to reflect the selected date
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selectdate,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blue),
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
                      DateTime.now().subtract(const Duration(days: 3)),
                      controller: _controller,
                      initialSelectedDate: _selectedDate,
                      selectionColor: Colors.blue,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) async {
                        setState(() {
                          _selectedDate = date;
                        });
                        await _fetchEventsByDate(_selectedDate);
                        _controller
                            .animateToSelection(); // Update the timeline to reflect the selected date
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: _eventsByDate.isEmpty
                        ? [
                            const Center(
                              child: Text('No events for selected date'),
                            ),
                          ]
                        : _eventsByDate
                            .expand(
                              (eventByDate) => eventByDate.events.map(
                                (event) => GestureDetector(
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 7),
                                      height:
                                          80, // Increase the height of the container
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              color: Colors
                                                  .blue, // Blue background color
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 7,
                                                horizontal: 4,
                                              ),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                '${_formatTime(event.time)}',
                                                style: const TextStyle(
                                                  color: Colors
                                                      .white, // White text color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              color: Colors
                                                  .white, // White background color
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${event.eventName} - ${event.category}', // Event name in blue color
                                                    style: const TextStyle(
                                                      color: Colors
                                                          .blue, // Blue text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
