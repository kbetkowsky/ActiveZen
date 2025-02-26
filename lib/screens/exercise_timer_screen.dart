import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseTimerScreen extends StatefulWidget {
  final String exerciseName;
  final int minutes;
  final double caloriesPerMinute;

  const ExerciseTimerScreen({
    super.key,
    required this.exerciseName,
    required this.minutes,
    required this.caloriesPerMinute,
  });

  @override
  _ExerciseTimerScreenState createState() => _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends State<ExerciseTimerScreen> {
  late int _secondsRemaining;
  Timer? _timer;
  bool isRunning = false;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.minutes * 60;
  }

  void _startTimer() {
    if (_timer != null) return;
    setState(() {
      isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopTimer();
        setState(() {
          finished = true;
        });
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
      finished = false;
    });
  }

  String get timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _saveExerciseHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    int minutes = widget.minutes;
    int caloriesBurned = (minutes * widget.caloriesPerMinute).toInt();

    await FirebaseFirestore.instance.collection('exerciseHistory').add({
      'uid': user.uid,
      'exerciseName': widget.exerciseName,
      'minutes': minutes,
      'calories': caloriesBurned,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ćwiczenie zapisane w historii')),
    );
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
            Text(timerText, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRunning ? _stopTimer : _startTimer,
              child: Text(isRunning ? 'Pauzuj Licznik' : 'Uruchom Licznik'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetTimer,
              child: const Text('Resetuj Licznik'),
            ),
            const SizedBox(height: 20),
            if (finished || !isRunning)
              ElevatedButton(
                onPressed: _saveExerciseHistory,
                child: const Text('Zakończ Ćwiczenie'),
              ),
          ],
        ),
      ),
    );
  }
}
