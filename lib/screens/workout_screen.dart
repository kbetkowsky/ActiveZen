import 'package:fitappv2/screens/favorite.dart';
import 'package:fitappv2/screens/workout_detail.dart';
import 'package:flutter/material.dart';
import '../service/workout_service.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final TextEditingController _bodyPartController = TextEditingController();
  List<dynamic> _workouts = [];
  bool _loading = false;
  List<dynamic> _favorites = []; // To store favorite workouts

  Future<void> fetchWorkouts() async {
    setState(() => _loading = true);

    // Allowed body part parameters
    final List<String> allowedBodyParts = [
      "back",
      "cardio",
      "chest",
      "lower arms",
      "lower legs",
      "neck",
      "shoulders",
      "upper arms",
      "upper legs",
      "waist"
    ];

    String input = _bodyPartController.text.toLowerCase().trim();
    if (!allowedBodyParts.contains(input)) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Parameter must be one of: back, cardio, chest, lower arms, lower legs, neck, shoulders, upper arms, upper legs, waist"),
        ),
      );
      return;
    }

    try {
      List<dynamic> result = await WorkoutService.getWorkoutPlans(input);
      setState(() => _workouts = result);
    } catch (e) {
      setState(() => _workouts = [
            {"name": "Error fetching data"}
          ]);
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Plans"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favorites: _favorites),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bodyPartController,
              decoration: InputDecoration(
                labelText: "Enter Body Part (e.g., chest, legs, arms)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWorkouts,
              child: Text("Get Workout Plan"),
            ),
            SizedBox(height: 16),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    // Pull-to-refresh functionality
                    child: RefreshIndicator(
                      onRefresh: fetchWorkouts,
                      child: ListView.builder(
                        itemCount: _workouts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_workouts[index]["name"] ??
                                "No exercise found"),
                            subtitle: Text(
                                "Target: ${_workouts[index]["target"] ?? "N/A"}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutDetailScreen(
                                    workout: _workouts[index],
                                    onFavorite: () {
                                      setState(() {
                                        if (!_favorites
                                            .contains(_workouts[index])) {
                                          _favorites.add(_workouts[index]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
