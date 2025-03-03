import 'package:fitappv2/screens/push_ups.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:lottie/lottie.dart';

class JumpingJacksScreen extends StatefulWidget {
  const JumpingJacksScreen({super.key});

  @override
  _JumpingJacksScreenState createState() => _JumpingJacksScreenState();
}

class _JumpingJacksScreenState extends State<JumpingJacksScreen> {
  late Timer _timer;
  int _start = 120;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PushUpsScreen()),
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
        title: const Text('Pajacyki'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("Zaczynamy!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Row(
              children: [
                Expanded(
                  child: Lottie.asset("images/jumpingjacks.json"),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: CustomPaint(
                      painter: TimerPainter(progress: _start / 120),
                      child: Center(
                        child: Text(
                          '$_start',
                          style: const TextStyle(
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
            const SizedBox(height: 30),
            const Text(
              'Pajacyki to prosty, ale skuteczny sposób na pobudzenie całego ciała. '
              'To dynamiczne ćwiczenie angażuje mięśnie nóg, ramion oraz brzucha, '
              'poprawiając krążenie i zwiększając tlenowanie organizmu. '
              'Jest idealne na początek dnia, aby szybko rozbudzić się i przygotować ciało do wyzwań dnia. '
              'Dodatkowo, regularne wykonywanie pajacyków może poprawić Twoją kondycję, wytrzymałość '
              'oraz wspomóc spalanie kalorii.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
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

class NextExerciseScreen extends StatelessWidget {
  const NextExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Następne Ćwiczenie'),
      ),
      body: const Center(),
    );
  }
}
