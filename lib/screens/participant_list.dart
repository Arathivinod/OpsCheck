import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParticipantListScreen extends StatefulWidget {
  @override
  _ParticipantListScreenState createState() => _ParticipantListScreenState();
}

class _ParticipantListScreenState extends State<ParticipantListScreen> {
  List<dynamic> participants = [];

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future<void> fetchParticipants() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/api/v1/participants'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        participants = jsonData['data']['participants'];
      });
    } else {
      throw Exception('Failed to load participants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Participant List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // App bar color
      ),
      body: participants.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show progress indicator if data is loading
          : ListView.builder(
              itemCount: participants.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: Color.fromARGB(255, 203, 227, 247), // Card color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      participants[index]['participantName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${participants[index]['participantId']}'),
                  ),
                );
              },
            ),
    );
  }
}
