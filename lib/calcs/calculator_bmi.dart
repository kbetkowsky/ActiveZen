import 'package:flutter/material.dart';

class BmiCalculatorScreen extends StatefulWidget {
  @override
  _BmiCalculatorScreenState createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _resultText = '';

  void calculateBMI() {
    double height =
        double.parse(_heightController.text) / 100; // przelicza na metry
    double weight = double.parse(_weightController.text);
    double bmi = weight / (height * height);

    setState(() {
      _bmi = bmi;
      if (_bmi < 18.5) {
        _resultText = 'Niedowaga';
      } else if (_bmi < 25) {
        _resultText = 'Normalna waga';
      } else if (_bmi < 30) {
        _resultText = 'Nadwaga';
      } else {
        _resultText = 'Otyłość';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMI'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Korzyści z używania kalkulatora BMI",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Korzystanie z kalkulatora BMI pozwala na monitorowanie wagi w kontekście wzrostu, co jest ważne dla utrzymania zdrowego stylu życia. Regularne sprawdzanie BMI może pomóc w zapobieganiu chorobom związanym z nadwagą i otyłością.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Wzrost w cm',
                icon: Icon(Icons.trending_up),
              ),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Waga w kg',
                icon: Icon(Icons.line_weight),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateBMI,
              child: Text('Oblicz BMI'),
            ),
            SizedBox(height: 20),
            Text(
              _bmi == 0
                  ? 'Wprowadź dane'
                  : 'Twoje BMI: ${_bmi.toStringAsFixed(2)} \n$_resultText',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
