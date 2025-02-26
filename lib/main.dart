import 'dart:io';

import 'package:fitappv2/screens/login_screen.dart';
import 'package:fitappv2/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCpzE11aE7kicqoqW1uXzbi_fxzYjj29uo',
            appId: '1:236562288830:android:c0df68b0caded1128b0eef',
            messagingSenderId: '236562288830',
            projectId: 'fitappv2',
            storageBucket: 'fitappv2.appspot.com',
          ),
        )
      : const SizedBox();

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Animate(
              effects: const [
                FadeEffect(delay: Duration(seconds: 1)),
                SlideEffect()
              ],
              child: ClipOval(
                child: Image.asset('images/logo.png'),
              ),
            ),
            Animate(
              effects: const [AlignEffect(curve: Curves.bounceIn)],
              child: const Text("Active Zen - Twoja codzienna dawka energii"),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Zaloguj się'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Zarejestruj się'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MainScreen()),
            //     );
            //   },
            //   child: Text('Przejdź do aplikacji'),
            // ),
          ],
        ),
      ),
    );
  }
}
