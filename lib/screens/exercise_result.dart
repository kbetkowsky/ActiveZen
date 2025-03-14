import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_timer_screen.dart';

class ExerciseResultScreen extends StatefulWidget {
  final int targetCalories;

  const ExerciseResultScreen({super.key, required this.targetCalories});

  @override
  _ExerciseResultScreenState createState() => _ExerciseResultScreenState();
}

class _ExerciseResultScreenState extends State<ExerciseResultScreen> {
  List<Map<String, dynamic>> exercisePlan = [];
  int totalCaloriesBurned = 0;

  @override
  void initState() {
    super.initState();
    _calculateExerciseSet();
  }

  Future<void> _calculateExerciseSet() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Exercises').get();

    List<Map<String, dynamic>> exercises =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    int targetCalories = widget.targetCalories;
    int numExercises = exercises.length;
    List<Map<String, dynamic>> plan = [];
    int totalCalories = 0;

    double caloriesPerExercise = targetCalories / numExercises;

    for (var exercise in exercises) {
      double cpm = exercise['caloriesPerMinute'].toDouble();
      int minutes = (caloriesPerExercise / cpm).ceil();
      int caloriesBurned = (minutes * cpm).toInt();
      plan.add({
        'name': exercise['name'],
        'minutes': minutes,
        'calories': caloriesBurned,
        'caloriesPerMinute': cpm,
      });
      totalCalories += caloriesBurned;
    }

    setState(() {
      exercisePlan = plan;
      totalCaloriesBurned = totalCalories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Ćwiczeń'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Całkowite kalorie do spalenia: $totalCaloriesBurned kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercisePlan.length,
              itemBuilder: (context, index) {
                var exercise = exercisePlan[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(exercise['name']),
                    subtitle: Text(
                        '${exercise['minutes']} min | Spala ~${exercise['calories']} kcal'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseTimerScreen(
                              exerciseName: exercise['name'],
                              minutes: exercise['minutes'],
                              caloriesPerMinute: exercise['caloriesPerMinute'],
                            ),
                          ),
                        );
                      },
                      child: const Text('Włącz licznik'),
                    ),
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
