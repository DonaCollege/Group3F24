import 'package:flutter/material.dart';
import 'screen/profile_screen.dart';

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
  primaryColor: 
  const Color.fromARGB(255, 3, 96, 255),
  scaffoldBackgroundColor: const Color.fromARGB(210, 0, 80, 137),
  appBarTheme: AppBarTheme(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromARGB(255, 255, 255, 255),
    border: OutlineInputBorder(),
  ),
  buttonTheme: ButtonThemeData(buttonColor: const Color.fromARGB(255, 255, 255, 255)),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.white),  // Use for headings
    bodyMedium: TextStyle(color: Colors.white),  // Use for regular body text
    bodySmall: TextStyle(color: Colors.white),   // Use for smaller text
  ),
),

      home: ProfileScreen(),
    );
  }
}
