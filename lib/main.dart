import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' show MaterialLocalizations, DefaultMaterialLocalizations;

import 'screens/dashboard_page.dart';
import 'screens/login/login_page.dart';
import 'screens/nutrition_logging_page.dart';
import 'screens/user_profile_page.dart';

void main() {
  runApp(const OptiFitApp());
}

class OptiFitApp extends StatelessWidget {
  const OptiFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OptiFitAppState(),
      child: CupertinoApp(
        title: 'OptiFit App',
        theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemPurple,
        ),
        localizationsDelegates: const [
          DefaultCupertinoLocalizations.delegate,
          DefaultMaterialLocalizations.delegate, // Add this
          // GlobalMaterialLocalizations.delegate,  // Add this
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
        ],
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
  const MyHomePage({super.key});

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
      case 1:
        page = const NutritionLoggingPage();
      case 2:
        page = const UserProfilePage();
      default:
        throw UnimplementedError('no widget for \$selectedIndex');
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('OptiFit'),
        trailing: appState.isLoggedIn
            ? CupertinoButton(
                child: const Icon(CupertinoIcons.square_arrow_right),
                onPressed: () {
                  appState.logout();
                  setState(() {
                    selectedIndex = 0; // Reset to dashboard on logout
                  });
                })
            : null,
      ),
      child: SafeArea(
        // Use a Column to lay out the tab bar and the page content
        child: Column(
          children: [
            Expanded(
              child: page, // Your main page content
            ),
            CupertinoTabBar( // Place CupertinoTabBar *inside* the child
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add_circled),
                  label: 'Log Nutrition',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}