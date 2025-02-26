import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FoodCalorieChecker(),
  ));
}

class FoodCalorieChecker extends StatefulWidget {
  @override
  _FoodCalorieCheckerState createState() => _FoodCalorieCheckerState();
}

class _FoodCalorieCheckerState extends State<FoodCalorieChecker> {
  final TextEditingController _foodController = TextEditingController();
  String _caloriesResult = "";

  Future<void> fetchCalories() async {
    final String food = _foodController.text.trim();
    if (food.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proszę wprowadzić nazwę jedzenia!')),
      );
      return;
    }

    final url = Uri.parse(
        'https://edamam-food-and-grocery-database.p.rapidapi.com/api/food-database/v2/parser?ingr=$food');

    final headers = {
      'x-rapidapi-key': 'ce31c13c4dmsh987eb25d74642fap14cd69jsn94e2532e2247',
      'x-rapidapi-host': 'edamam-food-and-grocery-database.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);

      print("Request URL: $url");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['hints'] != null && data['hints'].isNotEmpty) {
          final foodItem = data['hints'][0]['food'];
          if (foodItem != null && foodItem['nutrients']['ENERC_KCAL'] != null) {
            int calories = foodItem['nutrients']['ENERC_KCAL'].toInt();
            setState(() {
              _caloriesResult = "$calories kcal";
            });
          } else {
            setState(() {
              _caloriesResult = "Brak danych o kaloriach!";
            });
          }
        } else {
          setState(() {
            _caloriesResult = "Brak danych o jedzeniu!";
          });
        }
      } else {
        setState(() {
          _caloriesResult =
              "Błąd podczas pobierania danych! (${response.statusCode})";
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        _caloriesResult = "Błąd sieci!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sprawdzanie Kalorii Jedzenia")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _foodController,
              decoration: InputDecoration(
                labelText: "Wprowadź nazwę jedzenia",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchCalories,
              child: Text("Sprawdź Kalorie"),
            ),
            SizedBox(height: 20),
            Text(
              _caloriesResult,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
