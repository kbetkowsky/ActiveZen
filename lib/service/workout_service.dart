import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutService {
  static const String apiUrl =
      "https://exercisedb.p.rapidapi.com/exercises/bodyPart/";
  static const String apiKey =
      "ce31c13c4dmsh987eb25d74642fap14cd69jsn94e2532e2247"; // Replace with your actual key

  static Future<List<dynamic>> getWorkoutPlans(String bodyPart) async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl$bodyPart"),
        headers: {
          "X-RapidAPI-Key": apiKey,
          "X-RapidAPI-Host": "exercisedb.p.rapidapi.com",
        },
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to fetch workout plans");
    }
  }
}
