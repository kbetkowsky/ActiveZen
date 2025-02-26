import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseHistoryScreen extends StatelessWidget {
  const ExerciseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Historia Ćwiczeń')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('exerciseHistory')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Brak dostępnej historii.'));
          }

          int totalMinutes = 0;
          int totalCalories = 0;

          List<Widget> tiles = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            String exerciseName = data['exerciseName'] ?? 'Brak nazwy';
            int minutes = data['minutes'] ?? 0;
            int calories = data['calories'] ?? 0;

            totalMinutes += minutes;
            totalCalories += calories;

            return ListTile(
              title: Text(exerciseName),
              subtitle: Text(
                'Czas trwania: $minutes min, Kalorie: $calories kcal',
              ),
            );
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Całkowity czas: $totalMinutes min\n'
                  'Całkowite kalorie: $totalCalories kcal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(children: tiles),
              ),
            ],
          );
        },
      ),
    );
  }
}
