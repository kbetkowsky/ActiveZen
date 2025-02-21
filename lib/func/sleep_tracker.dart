import 'package:flutter/material.dart';

class SleepTrackerWidget extends StatefulWidget {
  @override
  _SleepTrackerWidgetState createState() => _SleepTrackerWidgetState();
}

class _SleepTrackerWidgetState extends State<SleepTrackerWidget> {
  DateTime sleepStart = DateTime.now().subtract(Duration(hours: 12));
  DateTime sleepEnd = DateTime.now();

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
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isStart) {
            sleepStart = pickedDateTime;
          } else {
            sleepEnd = pickedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Korzyści ze zdrowego snu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Zdrowy sen jest kluczowy dla dobrego zdrowia i samopoczucia. Pomaga w poprawie koncentracji, nastroju, wspiera zdrowie serca i układu odpornościowego, oraz przyczynia się do lepszego ogólnego stanu zdrowia.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4.0,
              child: ExpansionTile(
                title: Text(
                  'Sleep Tracker',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('Sleep Start'),
                    trailing: Text('${sleepStart.toString()}'),
                    onTap: () => _selectDateAndTime(context, true),
                  ),
                  ListTile(
                    title: Text('Sleep End'),
                    trailing: Text('${sleepEnd.toString()}'),
                    onTap: () => _selectDateAndTime(context, false),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        // Zapisz dane snu
                      },
                      child: Text('Save Sleep Data'),
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
