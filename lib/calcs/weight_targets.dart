import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _addWeight() async {
    double weight = double.tryParse(_weightController.text) ?? 0;
    if (weight <= 0) return;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference weightCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('weight_history');

    QuerySnapshot snapshot =
        await weightCollection.orderBy('id', descending: true).limit(1).get();
    int newId = snapshot.docs.isNotEmpty ? snapshot.docs.first['id'] + 1 : 1;

    await weightCollection.doc(newId.toString()).set({
      'id': newId,
      'weight': weight,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _weightController.clear();
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _getWeights() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference weightCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('weight_history');

    QuerySnapshot snapshot =
        await weightCollection.orderBy('id', descending: false).get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> _saveUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentReference userInfoDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);

    await userInfoDoc.set({
      'height': double.tryParse(_heightController.text) ?? 0,
      'targetWeight': double.tryParse(_targetWeightController.text) ?? 0,
      'age': int.tryParse(_ageController.text) ?? 0,
      'isMale': isMale,
    });
  }

  Future<void> _loadUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentReference userInfoDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);

    DocumentSnapshot snapshot = await userInfoDoc.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _heightController.text = data['height'].toString();
        _targetWeightController.text = data['targetWeight'].toString();
        _ageController.text = data['age'].toString();
        isMale = data['isMale'] ?? true;
      });
    }
  }

  void _calculateWeightTarget() {
    double? weight = double.tryParse(_weightController.text);
    double? height = double.tryParse(_heightController.text);
    double? targetWeight = double.tryParse(_targetWeightController.text);
    int? age = int.tryParse(_ageController.text);

    if (weight == null ||
        height == null ||
        targetWeight == null ||
        age == null) {
      setState(() {
        resultText = 'Proszę wprowadzić poprawne wartości.';
      });
      return;
    }

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
      appBar: AppBar(title: const Text('Cele wagowe')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                decoration: const InputDecoration(labelText: 'Waga (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Wzrost (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _targetWeightController,
                decoration: const InputDecoration(labelText: 'Cel Wagowy (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Wiek (lata)'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  _calculateWeightTarget();
                  _saveUserInfo();
                },
                child: const Text('Oblicz i Zapisz'),
              ),
              const SizedBox(height: 20),
              Text(resultText),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addWeight,
                child: const Text('Dodaj Wagę'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: FutureBuilder(
                  future: _getWeights(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return WeightGraph(weightData: snapshot.data!);
                    }
                    return const Center(child: Text("Brak danych o wadze."));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightGraph extends StatelessWidget {
  final List<Map<String, dynamic>> weightData;
  const WeightGraph({super.key, required this.weightData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: weightData.map((data) {
              return FlSpot(data['id'].toDouble(), data['weight']);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
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
    double bmr = isMale
        ? (10 * weight + 6.25 * height - 5 * age + 5)
        : (10 * weight + 6.25 * height - 5 * age - 161);

    double dailyCalories = bmr * 1.55;
    double weightDifference = weight - targetWeight;
    int weeksToTarget = (weightDifference.abs() / 0.5).ceil();

    return {'dailyCalories': dailyCalories, 'weeksToTarget': weeksToTarget};
  }
}
