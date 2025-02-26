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
  String? _selectedBodyPart; // To store the selected body part

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

  Future<void> fetchWorkouts() async {
    setState(() => _loading = true);

    if (_selectedBodyPart == null ||
        !allowedBodyParts.contains(_selectedBodyPart)) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Parametr nieprawidłowy"),
        ),
      );
      return;
    }

    try {
      List<dynamic> result =
          await WorkoutService.getWorkoutPlans(_selectedBodyPart!);
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
        title: Text("Pobierz Ćwiczenie"),
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
            DropdownButtonFormField<String>(
              value: _selectedBodyPart,
              decoration: const InputDecoration(
                labelText: "Wybierz partie ciała",
                border: OutlineInputBorder(),
              ),
              items: allowedBodyParts.map((String bodyPart) {
                return DropdownMenuItem<String>(
                  value: bodyPart,
                  child: Text(bodyPart),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBodyPart = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWorkouts,
              child: Text("Pobierz"),
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
