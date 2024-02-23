import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:opscheck/modal/modal.dart';
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

class ParticipantListScreenState extends State<ParticipantListScreen> {
  List<Participant> _participants = [];
  bool _isLoading = false;
  String _eventName = '';
  String _category = '';

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
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
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load participants');
      }
    } catch (error) {
      // print('Error fetching participants: $error');
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
        _fetchParticipants();
      } else {
        throw Exception('Failed to update participation mode');
      }
    } catch (error) {
      print('Error updating participation mode: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Participants',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(
                                eventName: _eventName,
                                category: _category,
                                officeParticipants: _participants
                                    .where((p) => p.participationMode == 1)
                                    .length,
                                wfhParticipants: _participants
                                    .where((p) => p.participationMode == 2)
                                    .length,
                                absentParticipants: _participants
                                    .where((p) => p.participationMode == 3)
                                    .length,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '$_eventName - $_category',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.zero,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 2)),
                            Spacer(),
                            ModeIcon(
                              icon: Icons.work,
                              color: Colors.blue,
                              label: 'Office',
                            ),
                            // SizedBox(width: 1),
                            ModeIcon(
                              icon: Icons.home,
                              color: Colors.green,
                              label: 'WFH',
                            ),
                            // SizedBox(width: 0),
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
                          color: const Color.fromARGB(255, 243, 249, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
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
            ),
    );
  }
}
