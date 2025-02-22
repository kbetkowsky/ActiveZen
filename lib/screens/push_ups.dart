import 'package:fitappv2/screens/jumping_jacks.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:lottie/lottie.dart';

class PushUpsScreen extends StatefulWidget {
  @override
  _PushUpsScreenState createState() => _PushUpsScreenState();
}

class _PushUpsScreenState extends State<PushUpsScreen> {
  late Timer _timer;
  int _start = 3;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            // Navigate to the next exercise screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JumpingJacksScreen()),
            );
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Ups'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("Let's Start!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Row(
              children: [
                Expanded(
                  child: Lottie.asset("images/push_ups.json"),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: CustomPaint(
                      painter: TimerPainter(progress: _start / 3),
                      child: Center(
                        child: Text(
                          '$_start',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Push Ups are a great exercise to strengthen your upper body. '
              'They work your chest, shoulders, triceps, and core muscles. '
              'Regular push ups can help improve your overall fitness and endurance.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class NextExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Exercise'),
      ),
      body: Center(
          // Content for the next exercise screen
          ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;

  TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    double angle = 2 * math.pi * progress;
    Offset handEnd = size.center(Offset.zero) +
        Offset(math.sin(angle), -math.cos(angle)) * (size.width / 2);
    canvas.drawLine(
        size.center(Offset.zero), handEnd, paint..color = Colors.red);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
