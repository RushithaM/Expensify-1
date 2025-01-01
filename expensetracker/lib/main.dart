import 'package:expensetracker/base.dart';
import 'package:expensetracker/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expensetracker/providers/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
  ));
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

String bUrl = 'https://expense-tracker-backend-nu.vercel.app';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (prefs!.getBool('login') == true) ? BasePage() : LoginPage(),
    );
  }
}
