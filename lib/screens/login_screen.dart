import 'package:fitappv2/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // flaga do śledzenia stanu ładowania

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ekran Logowania')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Animate(
                child: Lottie.asset("images/ekran_logowania.json"),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Hasło',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Zaloguj się'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    print('Rozpoczęcie procesu logowania...');
    setState(() {
      _isLoading = true; // Pokaż wskaźnik ładowania
    });

    try {
      print('Próba logowania z email: ${_emailController.text.trim()}');
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('Logowanie zakończone sukcesem');
      // Sukces, przenieś użytkownika do HomeScreen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Błąd logowania: Nie znaleziono użytkownika');
        _showErrorDialog('Nie znaleziono użytkownika dla tego adresu e-mail.');
      } else if (e.code == 'wrong-password') {
        print('Błąd logowania: Niepoprawne hasło');
        _showErrorDialog('Niepoprawne hasło.');
      }
    } catch (e) {
      print('Błąd logowania: $e');
      _showErrorDialog('Wystąpił błąd: $e');
    } finally {
      setState(() {
        _isLoading = false; // Ukryj wskaźnik ładowania
        print('Proces logowania zakończony');
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Błąd'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
