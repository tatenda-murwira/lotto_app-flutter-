import 'package:flutter/material.dart';


import 'package:lottery/screens/home_screen.dart' as home;
import 'screens/login_screen.dart' as login; 
import 'screens/register_screen.dart';
import 'screens/purchase_screen.dart';
import 'screens/results_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  
  runApp(LotteryApp());
}

class LotteryApp extends StatefulWidget {
  @override
  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LotteryApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery App',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), 
      initialRoute: '/login',
      routes: {
        '/login': (context) => login.LoginPage(), 
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => home.HomePage(),
        '/purchase': (context) => const PurchaseScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}
