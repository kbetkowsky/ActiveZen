import 'package:fitappv2/screens/jumping_jacks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class MorningRoutineScreen extends StatelessWidget {
  const MorningRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poranny Rozruch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Animate(child: Lottie.asset("images/nozyce.json")),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Poranny rozruch to świetny sposób na rozpoczęcie dnia! Pomaga obudzić ciało, '
                'poprawić krążenie i zwiększyć koncentrację. Regularne poranne ćwiczenia '
                'mogą przyczynić się do poprawy samopoczucia, zwiększenia energii i lepszego '
                'samopoczucia przez cały dzień. W kolejnym ekranie znajdziesz serię łatwych '
                'ćwiczeń, które możesz wykonać bez użycia dodatkowych przyrządów, wykorzystując jedynie wagę własnego ciała.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JumpingJacksScreen()),
                );
              },
              child: const Text('Zaczynamy'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  // Tutaj można zaimplementować ekran z ćwiczeniami
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ćwiczenia poranne'),
      ),
      body: const Center(
          // Zawartość ekranu z ćwiczeniami
          ),
    );
  }
}
