import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool speedingAlerts = true;
  bool harshBraking = false;
  bool routeWarnings = true;
  bool vibrateOnAlert = true;
  bool dndMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      speedingAlerts = prefs.getBool('speedingAlerts') ?? true;
      harshBraking = prefs.getBool('harshBraking') ?? false;
      routeWarnings = prefs.getBool('routeWarnings') ?? true;
      vibrateOnAlert = prefs.getBool('vibrateOnAlert') ?? true;
      dndMode = prefs.getBool('dndMode') ?? false;
    });
  }

  void _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: const Color.fromARGB(255, 45, 62, 80), // Updated background color
        child: ListView(
          children: [
            _buildSwitchTile('Speeding Alerts', speedingAlerts, (value) {
              setState(() {
                speedingAlerts = value;
                _savePreference('speedingAlerts', value);
              });
            }),
            _buildSwitchTile('Harsh Braking', harshBraking, (value) {
              setState(() {
                harshBraking = value;
                _savePreference('harshBraking', value);
              });
            }),
            _buildSwitchTile('Route Warnings', routeWarnings, (value) {
              setState(() {
                routeWarnings = value;
                _savePreference('routeWarnings', value);
              });
            }),
            _buildSwitchTile('Vibrate on Alert', vibrateOnAlert, (value) {
              setState(() {
                vibrateOnAlert = value;
                _savePreference('vibrateOnAlert', value);
              });
            }),
            _buildSwitchTile('Do Not Disturb (DND)', dndMode, (value) {
              setState(() {
                dndMode = value;
                _savePreference('dndMode', value);
              });
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 0, 60, 110),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: 1, // Set the default selected index to "Settings"
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/MyApp'); // Replace with your Dashboard route
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/MyApp'); // Replace with your Settings route
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/ProfileScreen'); // Replace with your Profile route
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
