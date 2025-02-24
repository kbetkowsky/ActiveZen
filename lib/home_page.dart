import 'package:fitappv2/calcs/calculator_bmi.dart';
import 'package:fitappv2/calcs/weight_targets.dart';
import 'package:fitappv2/func/sleep_tracker.dart';
import 'package:fitappv2/func/user_photos_widget.dart';
import 'package:fitappv2/screens/add_post_page.dart';
import 'package:fitappv2/screens/calorie_input.dart';
import 'package:fitappv2/screens/exercise_history.dart';
import 'package:fitappv2/screens/morning_routine.dart';
import 'package:fitappv2/screens/user_profile_page.dart';
import 'package:fitappv2/screens/view_post_screen.dart';
import 'package:fitappv2/screens/weight_history.dart';
import 'package:fitappv2/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Active Zen',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageWidget(),
    const UserProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white.withOpacity(0.8),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  final gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.2),
        Colors.blue.withOpacity(0.2),
        Colors.orange.withOpacity(0.2),
      ],
    ),
  );

  HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientDecoration,
      child: Scaffold(
        appBar: AppBar(title: const Text('Active Zen'), elevation: 0),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _sectionTitle("Nasza misja:"),
              _sectionTitle("Aktywność Fizyczna"),
              Animate(child: Lottie.asset("images/mikolaj.json")),
              _sectionText(
                  "Zwiększ swoją energię i popraw samopoczucie dzięki regularnej aktywności fizycznej..."),
              _sectionTitle("Zdrowy Sen"),
              Animate(child: Lottie.asset("images/spanko.json")),
              _sectionText(
                  "Dobry sen jest fundamentem zdrowego życia. Active Zen oferuje narzędzia do monitorowania i analizy snu..."),
              _sectionTitle("Zdrowa Waga"),
              Animate(child: Lottie.asset("images/waga.json")),
              _sectionText(
                  "Utrzymanie zdrowej wagi jest kluczem do dobrego zdrowia i samopoczucia..."),
              _sectionTitle("Jakość Jedzenia"),
              Animate(child: Lottie.asset("images/jedzenie.json")),
              _sectionText(
                  "Zdrowe odżywianie jest podstawą dobrego zdrowia. W Active Zen kładziemy nacisk na edukację żywieniową..."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu Aktywności',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(Icons.fitness_center, 'Poranny rozruch', () {
            _navigateTo(context, const MorningRoutineScreen());
          }),
          _drawerItem(Icons.balance, 'Kalkulator BMI', () {
            _navigateTo(context, const BmiCalculatorScreen());
          }),
          _drawerItem(Icons.assessment, 'Cele wagowe', () {
            _navigateTo(context, const WeightTargetsPage());
          }),
          _drawerItem(Icons.single_bed_sharp, 'Zdrowy sen', () {
            _navigateTo(context, SleepTrackerWidget());
          }),
          _drawerItem(Icons.add, 'Dodaj Post', () {
            _navigateTo(context, const AddPostPage());
          }),
          _drawerItem(Icons.data_array, 'Wyświetl posty', () {
            _navigateTo(context, const ViewPostsPage());
          }),
          _drawerItem(
              Icons.local_fire_department, 'Ćwiczenia do spalenia kalorii', () {
            _navigateTo(context, const CalorieInputScreen());
          }),
          _drawerItem(
            Icons.history,
            'Historia ćwiczeń',
            () {
              _navigateTo(context, const ExerciseHistoryScreen());
            },
          ),
          _drawerItem(Icons.api, 'API', () {
            _navigateTo(context, WorkoutScreen());
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
