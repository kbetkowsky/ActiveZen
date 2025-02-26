import 'package:fitappv2/screens/workout_detail.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<dynamic> favorites;

  const FavoritesScreen({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ulubione"),
      ),
      body: favorites.isEmpty
          ? Center(child: Text("Brak ulubionych ćwiczeń."))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final workout = favorites[index];
                return ListTile(
                  title: Text(workout['name'] ?? 'No Name'),
                  subtitle: Text("Target: ${workout['target'] ?? 'N/A'}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkoutDetailScreen(workout: workout),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
