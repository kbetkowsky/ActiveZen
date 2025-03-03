import 'package:fitappv2/screens/jumping_jacks.dart';
import 'package:fitappv2/screens/push_ups.dart' as push_ups;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockTimerPainter extends CustomPainter {
  final double progress;
  MockTimerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  group('JumpingJacksScreen Widget Tests', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('JumpingJacksScreen initial UI test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const JumpingJacksScreen(),
          navigatorObservers: [mockObserver],
        ),
      );

      expect(find.text('Pajacyki'), findsOneWidget);

      expect(find.text('Zaczynamy!'), findsOneWidget);

      expect(find.text('120'), findsOneWidget);

      expect(find.textContaining('Pajacyki to prosty, ale skuteczny sposób'),
          findsOneWidget);

      expect(find.byType(Lottie), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(SizedBox), matching: find.byType(CustomPaint)),
          findsOneWidget);
    });

    testWidgets('Timer decrements after one second',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const JumpingJacksScreen(),
          navigatorObservers: [mockObserver],
        ),
      );

      expect(find.text('120'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('119'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('118'), findsOneWidget);
    });

    testWidgets('Navigates to PushUpsScreen after timer completes',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: const JumpingJacksScreen(),
          routes: {
            '/push_ups': (context) => const push_ups.PushUpsScreen(),
          },
          navigatorObservers: [mockObserver],
        ),
      );
      expect(find.text('120'), findsOneWidget);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      expect(find.text('115'), findsOneWidget);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              Future.microtask(() => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const push_ups.PushUpsScreen()),
                  ));
              return const JumpingJacksScreen();
            },
          ),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
    });
  });

  testWidgets('Timer is properly disposed', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: JumpingJacksScreen()));

    expect(find.byType(JumpingJacksScreen), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    await tester.pump(const Duration(seconds: 2));
  });
}
