import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/login.dart';
import 'screen/help_support.dart';
import 'screen/term_and_condition.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the options from firebase_options.dart
  try {
    await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions.currentPlatform, // Use the generated options
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
    return; // Stop execution if Firebase initialization fails
  }

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
      home: LoginScreen(),
    );
  }
}
