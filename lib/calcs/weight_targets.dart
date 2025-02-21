import 'package:flutter/material.dart';

class WeightTargetsPage extends StatefulWidget {
  const WeightTargetsPage({super.key});

  @override
  _WeightTargetsPageState createState() => _WeightTargetsPageState();
}

class _WeightTargetsPageState extends State<WeightTargetsPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _ageController = TextEditingController();
  bool isMale = true;
  String resultText = '';

  void _calculateWeightTarget() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);
    double targetWeight = double.parse(_targetWeightController.text);
    int age = int.parse(_ageController.text);

    WeightTargets weightTargets = WeightTargets(
        weight: weight,
        height: height,
        targetWeight: targetWeight,
        age: age,
        isMale: isMale);
    Map<String, dynamic> results = weightTargets.calculateCaloriesAndTime();

    setState(() {
      resultText =
          'Dzienne kalorie: ${results['dailyCalories'].toStringAsFixed(2)}\n'
          'Tygodnie do celu: ${results['weeksToTarget']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cele wagowe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Korzyści płynące z korzystania z kalkulatora celu wagowego",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Dowiedz się, jakie są Twoje dzienne potrzeby kaloryczne, aby osiągnąć cel wagowy. Czy chcesz schudnąć, przytyć, czy utrzymać obecną wagę? Nasz kalkulator pomoże Ci ustalić realistyczne i zdrowe cele.",
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                value: isMale ? 'Male' : 'Female',
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    isMale = newValue == 'Male';
                  });
                },
              ),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Waga (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Wzrost (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _targetWeightController,
                decoration: InputDecoration(labelText: 'Cel Wagowy (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Wiek (lata)'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _calculateWeightTarget,
                child: Text('Oblicz'),
              ),
              SizedBox(height: 20),
              Text(resultText),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}

class WeightTargets {
  double weight;
  double height;
  double targetWeight;
  int age;
  bool isMale;

  WeightTargets({
    required this.weight,
    required this.height,
    required this.targetWeight,
    required this.age,
    required this.isMale,
  });

  Map<String, dynamic> calculateCaloriesAndTime() {
    double bmr;
    if (isMale) {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    double dailyCalories = bmr * 1.55; // Umiarkowana aktywność
    double weightDifference = weight - targetWeight;
    bool isWeightLoss = weightDifference > 0;
    double weeklyWeightChange = isWeightLoss ? -0.5 : 0.5; // 0.5 kg na tydzień
    int weeksToTarget =
        (weightDifference.abs() / weeklyWeightChange.abs()).ceil();

    // Ajustowanie kalorii dla celu wagowego
    double dailyCaloriesForGoal =
        dailyCalories + (isWeightLoss ? -500 : 500) * weeklyWeightChange.abs();

    return {
      'dailyCalories': dailyCaloriesForGoal,
      'weeksToTarget': weeksToTarget
    };
  }
}
