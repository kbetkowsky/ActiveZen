import 'dart:async';
import 'package:flutter/material.dart';

class ExerciseTimerScreen extends StatefulWidget {
  final String exerciseName;
  final int minutes;

  const ExerciseTimerScreen({
    Key? key,
    required this.exerciseName,
    required this.minutes,
  }) : super(key: key);

  @override
  _ExerciseTimerScreenState createState() => _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends State<ExerciseTimerScreen> {
  late int _secondsRemaining;
  Timer? _timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.minutes * 60;
  }

  void _startTimer() {
    if (_timer != null) return; // Timer already running.
    setState(() {
      isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _secondsRemaining = widget.minutes * 60;
    });
  }

  String get timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exerciseName} Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(timerText, style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRunning ? _stopTimer : _startTimer,
              child: Text(isRunning ? 'Pauzuj Timer' : 'Start Timer'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
