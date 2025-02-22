import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BmiCalculatorScreen extends StatefulWidget {
  @override
  _BmiCalculatorScreenState createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _resultText = '';

  void calculateBMI() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wprowadź poprawne dane!')),
      );
      return;
    }

    height = height / 100; // Convert cm to meters
    double bmi = weight / (height * height);

    setState(() {
      if (bmi < 18.5) {
        _resultText = 'Niedowaga';
      } else if (bmi < 25) {
        _resultText = 'Normalna waga';
      } else if (bmi < 30) {
        _resultText = 'Nadwaga';
      } else {
        _resultText = 'Otyłość';
      }
    });

    saveBMI();
  }

  Future<void> saveBMI() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('bmiHistory').add({
      'uid': user.uid,
      'height': double.tryParse(_heightController.text) ?? 0,
      'weight': double.tryParse(_weightController.text) ?? 0,
      'resultText': _resultText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('BMI wynik zapisany!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalkulator BMI')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Wzrost (cm)',
                icon: Icon(Icons.trending_up),
              ),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Waga (kg)',
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
              _resultText.isEmpty
                  ? 'Wprowadź dane'
                  : 'Twój wynik: $_resultText',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BmiHistoryScreen()),
                );
              },
              child: Text('Historia BMI'),
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

class BmiHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Historia BMI')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bmiHistory')
            .where('uid', isEqualTo: user?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Brak zapisanej historii BMI"));
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;

              String resultText = data['resultText'] ?? 'Brak danych';
              Timestamp? timestamp = data['timestamp'] as Timestamp?;
              String formattedTime = timestamp != null
                  ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
                  : 'Brak godziny';

              return ListTile(
                title: Text(resultText),
                subtitle: Text('Godzina: $formattedTime'),
                leading: Icon(Icons.bar_chart),
              );
            },
          );
        },
      ),
    );
  }
}
