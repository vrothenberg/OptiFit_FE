import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard_page.dart';
import 'screens/login/login_page.dart';
import 'screens/nutrition_logging_page.dart';
import 'screens/user_profile_page.dart';

void main() {
  runApp(const OptiFitApp());
}

class OptiFitApp extends StatelessWidget {
  const OptiFitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OptiFitAppState(),
      child: MaterialApp(
        title: 'OptiFit',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class OptiFitAppState extends ChangeNotifier {
  bool isLoggedIn = false;

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<OptiFitAppState>(context);

    if (!appState.isLoggedIn) {
      return const LoginPage();
    }

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = const NutritionLoggingPage();
        break;
      case 2:
        page = const UserProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for \$selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('OptiFit'),
      ),
      body: Center(
        child: page,
      ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Log Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          if (!appState.isLoggedIn)
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
