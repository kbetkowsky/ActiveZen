import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Historia BMI")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bmiHistory')
            .where('uid', isEqualTo: user?.uid) // Filter by user
            .orderBy('timestamp', descending: true) // Sort by newest first
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("Brak zapisanej historii BMI."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;

              // Convert Firestore timestamp to DateTime
              DateTime date = DateTime.now();
              if (data['timestamp'] is Timestamp) {
                date = (data['timestamp'] as Timestamp).toDate();
              }

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("BMI: ${data['bmi'].toStringAsFixed(2)}"),
                  subtitle: Text("Zapisano: ${date.toLocal()}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
