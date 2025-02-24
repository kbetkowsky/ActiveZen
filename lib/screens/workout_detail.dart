import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final dynamic workout;
  final VoidCallback? onFavorite;

  const WorkoutDetailScreen({Key? key, required this.workout, this.onFavorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout['name'] ?? 'Workout Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              if (onFavorite != null) {
                onFavorite!();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to favorites!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              workout['gifUrl'] != null
                  ? Image.network(workout['gifUrl'])
                  : Container(),
              SizedBox(height: 16),
              Text(
                workout['name'] ?? 'No Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Target: ${workout['target'] ?? 'N/A'}"),
              SizedBox(height: 8),
              Text("Body Part: ${workout['bodyPart'] ?? 'N/A'}"),
              SizedBox(height: 8),
              Text("Equipment: ${workout['equipment'] ?? 'N/A'}"),
            ],
          ),
        ),
      ),
    );
  }
}
