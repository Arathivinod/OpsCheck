import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:opscheck/models/model_participant.dart';
import 'summary_report.dart';

class ModeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const ModeIcon({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class ParticipantListScreen extends StatefulWidget {
  final int eventId;
  final DateTime eventDate;

  const ParticipantListScreen({required this.eventId, required this.eventDate});

  @override
  ParticipantListScreenState createState() => ParticipantListScreenState();
}

class ParticipantListScreenState extends State<ParticipantListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Participant> _participants = [];
  List<Participant> _originalParticipants = [];
  bool _isLoading = false;
  String _eventName = '';
  String _category = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchParticipants();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchParticipants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(widget.eventDate);
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:3000/api/v1/analytics/${widget.eventId}?date=$formattedDate'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> participantsData =
            jsonData['data']['event']['participants'];

        setState(() {
          _eventName = jsonData['data']['event']['eventName'];
          _category = jsonData['data']['event']['category'];

          _participants = participantsData
              .map((data) => Participant(
                    participantId: data['participantId'],
                    participantName: data['participantName'],
                    participationMode: data['eventparticipantmapping']
                        ['participationMode'],
                  ))
              .toList();
          _originalParticipants = List.from(_participants); // Copy list
          _participants
              .sort((a, b) => a.participantName.compareTo(b.participantName));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load participants');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateParticipationMode(
      int participantId, int mode, DateTime date) async {
    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:3000/api/v1/analytics/${widget.eventId}'),
        body: json.encode({
          'participantId': participantId,
          'participationMode': mode,
          'date': DateFormat('yyyy-MM-dd').format(date)
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        setState(() {
          // Update mode in the original list without changing its position
          final participantIndex = _originalParticipants
              .indexWhere((p) => p.participantId == participantId);
          if (participantIndex != -1) {
            _originalParticipants[participantIndex].participationMode = mode;
            _participants =
                List.from(_originalParticipants); // Update displayed list
            _participants
                .sort((a, b) => a.participantName.compareTo(b.participantName));
          }
        });
      } else {
        throw Exception('Failed to update participation mode');
      }
    } catch (error) {
      print('Error updating participation mode: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Participants'),
              Tab(text: 'Report'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildParticipantsTab(),
            EventDetailsScreen(
              eventName: _eventName,
              category: _category,
              eventId: widget.eventId,
              selectedDate: widget.eventDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '$_eventName - $_category',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.zero,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          ModeIcon(
                            icon: Icons.work,
                            color: Colors.blue,
                            label: 'Office',
                          ),
                          ModeIcon(
                            icon: Icons.home,
                            color: Colors.green,
                            label: 'WFH',
                          ),
                          ModeIcon(
                            icon: Icons.not_interested,
                            color: Colors.red,
                            label: 'Absent',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _participants.length,
                  itemBuilder: (BuildContext context, int index) {
                    final participant = _participants[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 7),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(participant.participantName),
                              subtitle:
                                  Text('ID: ${participant.participantId}'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: IconButton(
                              icon: Icon(Icons.work,
                                  color: participant.participationMode == 1
                                      ? Colors.blue
                                      : Colors.grey),
                              onPressed: () {
                                _updateParticipationMode(
                                    participant.participantId,
                                    1,
                                    DateTime.now());
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: IconButton(
                              icon: Icon(Icons.home,
                                  color: participant.participationMode == 2
                                      ? Colors.green
                                      : Colors.grey),
                              onPressed: () {
                                _updateParticipationMode(
                                    participant.participantId,
                                    2,
                                    DateTime.now());
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: IconButton(
                              icon: Icon(Icons.not_interested,
                                  color: participant.participationMode == 3
                                      ? Colors.red
                                      : Colors.grey),
                              onPressed: () {
                                _updateParticipationMode(
                                    participant.participantId,
                                    3,
                                    DateTime.now());
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
