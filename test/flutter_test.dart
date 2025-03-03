import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitappv2/calcs/calculator_bmi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';
import 'package:fitappv2/main.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  testWidgets('Invalid input shows Snackbar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BmiCalculatorScreen()));

    await tester.enterText(find.byType(TextField).at(0), 'abc');
    await tester.enterText(find.byType(TextField).at(1), '-70');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Oblicz BMI'));
    await tester.pump();

    expect(find.text('Wprowadź poprawne dane!'), findsOneWidget);
  });
}
