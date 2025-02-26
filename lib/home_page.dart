import 'package:fitappv2/calcs/calculator_bmi.dart';
import 'package:fitappv2/calcs/weight_targets.dart';
import 'package:fitappv2/func/sleep_tracker.dart';
import 'package:fitappv2/screens/add_post_page.dart';
import 'package:fitappv2/screens/calorie_input.dart';
import 'package:fitappv2/screens/eat_tracker.dart';
import 'package:fitappv2/screens/exercise_history.dart';
import 'package:fitappv2/screens/morning_routine.dart';
import 'package:fitappv2/screens/user_profile_page.dart';
import 'package:fitappv2/screens/view_post_screen.dart';
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    left: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.fitness_center,
                            size: 30,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Active Zen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.category, color: Colors.grey.shade700, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'KATEGORIE',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.grey.shade400, thickness: 1),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  _categorySection(
                    context,
                    "Aktywność",
                    [
                      _drawerItem(
                        context,
                        Icons.fitness_center,
                        'Poranny Rozruch',
                        const MorningRoutineScreen(),
                        Colors.orange,
                      ),
                      _drawerItem(
                        context,
                        Icons.local_fire_department,
                        'Ćwiczenia Do Spalenia Kalorii',
                        const CalorieInputScreen(),
                        Colors.orange,
                      ),
                      _drawerItem(
                        context,
                        Icons.find_in_page_outlined,
                        'Znajdź Ćwiczenie',
                        WorkoutScreen(),
                        Colors.orange,
                      ),
                      _drawerItem(
                        context,
                        Icons.history,
                        'Historia Ćwiczeń',
                        const ExerciseHistoryScreen(),
                        Colors.orange,
                      ),
                    ],
                  ),
                  _categorySection(
                    context,
                    "Zdrowie",
                    [
                      _drawerItem(
                        context,
                        Icons.balance,
                        'BMI',
                        const BmiCalculatorScreen(),
                        Colors.green,
                      ),
                      _drawerItem(
                        context,
                        Icons.single_bed_sharp,
                        'Zdrowy Sen',
                        SleepTrackerWidget(),
                        Colors.green,
                      ),
                    ],
                  ),
                  _categorySection(
                    context,
                    "Żywienie",
                    [
                      _drawerItem(
                        context,
                        Icons.fastfood,
                        'Sprawdź Kalorie',
                        FoodCalorieChecker(),
                        Colors.red,
                      ),
                      _drawerItem(
                        context,
                        Icons.assessment,
                        'Cele Wagowe',
                        const WeightTargetsPage(),
                        Colors.red,
                      ),
                    ],
                  ),
                  _categorySection(
                    context,
                    "Społeczność",
                    [
                      _drawerItem(
                        context,
                        Icons.add,
                        'Dodaj Post',
                        const AddPostPage(),
                        Colors.purple,
                      ),
                      _drawerItem(
                        context,
                        Icons.data_array,
                        'Wyświetl Posty',
                        const ViewPostsPage(),
                        Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categorySection(
      BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget destination,
    Color iconColor,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
