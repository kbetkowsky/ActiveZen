import 'package:fitappv2/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterSucessful extends StatelessWidget {
  const RegisterSucessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            // Wyrównaj do góry
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('images/register_successful.json'),
              const SizedBox(height: 16), // Dodaj odstęp pomiędzy elementami
              const Text(
                "Rejestracja przebiegła pomyślnie. Teraz możesz się zalogować, klikając przycisk poniżej.",
                textAlign: TextAlign.center, // Wyśrodkuj tekst
              ),
              const SizedBox(height: 16), // Dodaj odstęp pomiędzy elementami
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Ustaw kolor tła na biały
                ),
                child: const Text(
                  'Zaloguj się',
                  style: TextStyle(
                      color: Colors.black), // Ustaw kolor tekstu na czarny
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
