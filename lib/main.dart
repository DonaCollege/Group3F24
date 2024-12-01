import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trackwise/screen/appSettings.dart';
import 'package:trackwise/screen/notification.dart';
import 'package:trackwise/screen/profile_screen.dart';
import 'package:trackwise/screen/securitySettings.dart';
import 'screen/login.dart';
import 'firebase_options.dart';
import 'screen/dashboard.dart';
import 'screen/map.dart'; // Import the MapScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the options from firebase_options.dart
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
    return;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackwise',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 3, 96, 255),
        scaffoldBackgroundColor: const Color.fromARGB(210, 0, 80, 137),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color.fromARGB(255, 255, 255, 255),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      // Start with the LoginScreen
      home: AppSettingsPage(),
      // Define routes for navigation
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/map': (context) => MapScreen(), // Add the MapScreen route
      },
    );
  }
}
