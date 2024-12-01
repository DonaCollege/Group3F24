import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settings Screen',
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Use system theme mode by default
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Load the theme preference (you can use shared preferences or another method)
    // For now, we'll just set it to false (light mode)
  }

  void _toggleDarkMode(bool? value) {
    setState(() {
      _isDarkMode = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSettingOption('Account', () {
              // Handle account settings action
            }),
            _buildSettingOption('Privacy', () {
              // Handle privacy settings action
            }),
            _buildSettingOption('About', () {
              // Handle about settings action
            }),
            const SizedBox(height: 20),
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSwitchOption('Enable Notifications', true, (value) {
              // Handle notifications toggle
            }),
            _buildSwitchOption('Show Alerts', false, (value) {
              // Handle alerts toggle
            }),
            const SizedBox(height: 20),
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSwitchOption('Enable Dark Mode', _isDarkMode, _toggleDarkMode),
            _buildSettingOption('Theme', () {
              // Handle theme settings action
            }),
            _buildSettingOption('Font Size', () {
              // Handle font size settings action
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(String title, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchOption(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 2,
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
