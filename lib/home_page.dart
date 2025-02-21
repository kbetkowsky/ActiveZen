import 'package:fitappv2/calcs/calculator_bmi.dart';
import 'package:fitappv2/calcs/weight_targets.dart';
import 'package:fitappv2/func/sleep_tracker.dart';
import 'package:fitappv2/func/user_photos_widget.dart';
import 'package:fitappv2/screens/add_post_page.dart';
import 'package:fitappv2/screens/morning_routine.dart';
import 'package:fitappv2/screens/user_profile_page.dart';
import 'package:fitappv2/screens/view_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageWidget(), // Widget dla ekranu głównego
    UserProfilePage(), // Widget dla ekranu profilu
    // Możesz dodać więcej ekranów tutaj, jeśli potrzebujesz
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Aktywności',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Aktywność Fizyczna'),
              onTap: () {
                // Dodaj akcję po naciśnięciu
              },
            ),
            ListTile(
              leading: Icon(Icons.bedtime),
              title: Text('Zdrowy Sen'),
              onTap: () {
                // Dodaj akcję po naciśnięciu
              },
            ),
            ListTile(
              leading: Icon(Icons.balance),
              title: Text('Zdrowa Waga'),
              onTap: () {
                // Dodaj akcję po naciśnięciu
              },
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Jakość Jedzenia'),
              onTap: () {
                // Dodaj akcję po naciśnięciu
              },
            ),
          ],
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // Dodaj więcej elementów tutaj, jeśli potrzebujesz
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
  @override
  final gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.2), // Biały z przezroczystością
        Colors.blue.withOpacity(0.2), // Niebieski z przezroczystością
        Colors.orange.withOpacity(0.2) // Pomarańczowy z przezroczystością
      ],
    ),
  );
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientDecoration,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title:
              Text('Active Zen'), // Tutaj możesz ustawić tytuł swojej aplikacji
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu Aktywności',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Poranny rozruch'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MorningRoutineScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.balance),
                title: Text('Kalkulator BMI'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BmiCalculatorScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.assessment),
                title: Text('Cele wagowe'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeightTargetsPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Dodaj Post'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.data_array),
                title: Text('Wyświetl posty'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ViewPostsPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: gradientDecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nasza misja:",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Aktywność Fizyczna",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Animate(child: Lottie.asset("images/mikolaj.json")),
                  Text(
                    "Zwiększ swoją energię i popraw samopoczucie dzięki regularnej aktywności fizycznej. W Active Zen znajdziesz różnorodne programy treningowe, które pomogą Ci zbudować siłę, zwiększyć wytrzymałość i poprawić ogólną kondycję. Nasza aplikacja oferuje personalizowane wskazówki i śledzi postępy, motywując do osiągania celów fitness. Regularny ruch to także doskonały sposób na redukcję stresu i poprawę jakości snu.",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Zdrowy Sen",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Animate(child: Lottie.asset("images/spanko.json")),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Dobry sen jest fundamentem zdrowego życia. Active Zen oferuje narzędzia do monitorowania i analizy snu, pomagając Ci zrozumieć jego jakość i wpływ na codzienne funkcjonowanie. Oferujemy porady dotyczące higieny snu, które pomogą Ci szybciej zasypiać i głębiej odpoczywać. Regularny i spokojny sen wpływa pozytywnie na nastrój, koncentrację i ogólną kondycję fizyczną. Nasza aplikacja pomoże Ci ustalić optymalny harmonogram snu, dopasowany do Twojego stylu życia.",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Zdrowa Waga",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Animate(child: Lottie.asset("images/waga.json")),
                  Text(
                    "Utrzymanie zdrowej wagi jest kluczem do dobrego zdrowia i samopoczucia. W Active Zen dostarczamy narzędzia do śledzenia masy ciała i kompozycji ciała, pozwalając na monitorowanie postępów i dostosowywanie celów. Nasze spersonalizowane plany żywieniowe i przewodniki dietetyczne pomogą Ci w osiągnięciu zrównoważonej diety. Dzięki poradom ekspertów i motywującym wyzwaniom, aplikacja wspiera w utrzymaniu zdrowych nawyków żywieniowych, co przekłada się na lepsze samopoczucie i wyższą energię życiową.",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Jakość Jedzenia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Animate(child: Lottie.asset("images/jedzenie.json")),
                  Text(
                    "Zdrowe odżywianie jest podstawą dobrego zdrowia. W Active Zen kładziemy nacisk na edukację żywieniową i promowanie zdrowych wyborów. Nasza aplikacja oferuje przepisy kulinarne, które są nie tylko smaczne, ale również odżywcze i łatwe do przygotowania. Uczymy, jak czytać etykiety produktów i wybierać składniki najwyższej jakości. Regularne spożywanie zdrowych posiłków wpływa pozytywnie na energię, wydajność i ogólną kondycję zdrowotną. Z Active Zen nauczysz się tworzyć zdrowe nawyki żywieniowe, które będą służyć Ci przez całe życie.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
