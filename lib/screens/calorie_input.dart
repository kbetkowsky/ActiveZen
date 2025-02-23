import 'package:flutter/material.dart';
import 'exercise_result.dart'; // Create this next

class CalorieInputScreen extends StatefulWidget {
  const CalorieInputScreen({super.key});

  @override
  _CalorieInputScreenState createState() => _CalorieInputScreenState();
}

class _CalorieInputScreenState extends State<CalorieInputScreen> {
  final TextEditingController _calorieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spalaj kalorie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Ile kalorii chcesz spalić'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int calories = int.tryParse(_calorieController.text) ?? 0;
                if (calories > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExerciseResultScreen(targetCalories: calories),
                    ),
                  );
                }
              },
              child: const Text('Pokaż ćwiczenia'),
            ),
          ],
        ),
      ),
    );
  }
}
