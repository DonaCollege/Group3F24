import 'package:flutter/material.dart';
import 'package:trackwise/screen/trip_summary.dart';
import 'screen/login.dart'; // Import LoginPage here
import 'screen/profile_screen.dart'; // Import ProfileScreen if necessary

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackwise',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 3, 96, 255),
        scaffoldBackgroundColor: const Color.fromARGB(210, 0, 80, 137),
        appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(),
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: const Color.fromARGB(255, 255, 255, 255)),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: LoginPage(),
    );
  }
}
