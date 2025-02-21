import 'package:fitappv2/screens/register_sucessful.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Dodano import FirebaseAuth
import 'package:firebase_core/firebase_core.dart'; // Dla inicjalizacji Firebase

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ekran Rejestracji')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Animate(
                child: Lottie.asset("images/rejestracja.json"),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Hasło',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Potwierdź hasło',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Zarejestruj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print('Proszę wypełnić wszystkie pola');
      return;
    }

    if (password != confirmPassword) {
      print('Hasła nie są identyczne');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;
      print('Konto utworzone: ${userCredential.user?.email}');
      // Przekierowanie do ekranu RegisterSuccessful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterSucessful()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Podane hasło jest za słabe.');
      } else if (e.code == 'email-already-in-use') {
        print('Konto z tym adresem email już istnieje.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
