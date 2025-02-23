import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepTrackerWidget extends StatefulWidget {
  @override
  _SleepTrackerWidgetState createState() => _SleepTrackerWidgetState();
}

class _SleepTrackerWidgetState extends State<SleepTrackerWidget> {
  DateTime sleepStart = DateTime.now().subtract(Duration(hours: 12));
  DateTime sleepEnd = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _selectDateAndTime(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? sleepStart : sleepEnd;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          final DateTime pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            sleepStart = pickedDateTime;
          } else {
            sleepEnd = pickedDateTime;
          }
        });
      }
    }
  }

  String _calculateSleepMark(int sleepDuration) {
    if (sleepDuration >= 8) {
      return "Good";
    } else if (sleepDuration >= 6) {
      return "Average";
    } else {
      return "Poor";
    }
  }

  Future<void> _saveSleepData() async {
    final user = _auth.currentUser;
    if (user != null) {
      int sleepDuration = sleepEnd.difference(sleepStart).inHours;
      String sleepMark = _calculateSleepMark(sleepDuration);

      await FirebaseFirestore.instance.collection('sleepMarks').add({
        'userId': user.uid,
        'sleepStart': sleepStart.toIso8601String(),
        'sleepEnd': sleepEnd.toIso8601String(),
        'sleepDuration': sleepDuration,
        'sleepMark': sleepMark,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sleep data saved! Sleep Score: $sleepMark')),
      );
    }
  }

  void _viewSleepHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sleep Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Sleep Tracker",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4.0,
              child: ExpansionTile(
                title: Text(
                  'Log Sleep',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('Sleep Start'),
                    trailing: Text('${sleepStart.hour}:${sleepStart.minute}'),
                    onTap: () => _selectDateAndTime(context, true),
                  ),
                  ListTile(
                    title: Text('Sleep End'),
                    trailing: Text('${sleepEnd.hour}:${sleepEnd.minute}'),
                    onTap: () => _selectDateAndTime(context, false),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: ElevatedButton(
                      onPressed: _saveSleepData,
                      child: Text('Save Sleep Data'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: ElevatedButton(
                      onPressed: _viewSleepHistory,
                      child: Text('View Sleep History'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sleep History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sleepMarks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var sleepMarks = snapshot.data!.docs;
          if (sleepMarks.isEmpty) {
            return Center(child: Text('No sleep history found.'));
          }
          return ListView.builder(
            itemCount: sleepMarks.length,
            itemBuilder: (context, index) {
              var sleepData = sleepMarks[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    'Slept from: ${_formatDate(sleepData['sleepStart'])} to ${_formatDate(sleepData['sleepEnd'])}',
                  ),
                  subtitle: Text(
                    'Duration: ${sleepData['sleepDuration']} hours | Mark: ${sleepData['sleepMark']}',
                    style: TextStyle(
                      color: sleepData['sleepMark'] == "Good"
                          ? Colors.green
                          : sleepData['sleepMark'] == "Average"
                              ? Colors.orange
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')} | ${date.day}-${date.month}-${date.year}";
  }
}
