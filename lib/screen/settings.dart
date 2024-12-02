import 'package:flutter/material.dart';
import 'privacyPolicy.dart';
import 'appInfo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  bool isLocationEnabled = false;
  double textSize = 16.0;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // General Section
          _buildSectionHeader('General'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(selectedLanguage),
            onTap: () {
              // Handle language selection
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location Services'),
            subtitle: const Text('Allow app to access location'),
            trailing: Switch(
              value: isLocationEnabled,
              onChanged: (value) {
                setState(() {
                  isLocationEnabled = value;
                });
              },
            ),
          ),
          const Divider(),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Push Notifications'),
            subtitle: const Text('Enable notifications'),
            trailing: Switch(
              value: isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email Notifications'),
            onTap: () {
              // Handle email notification settings
            },
          ),
          const Divider(),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: Text(isDarkMode ? 'On' : 'Off'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Text Size'),
            subtitle: const Text('Adjust text size'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: textSize,
                min: 12,
                max: 24,
                divisions: 4,
                label: textSize.round().toString(),
                onChanged: (value) {
                  setState(() {
                    textSize = value;
                  });
                },
              ),
            ),
          ),
          const Divider(),

          // Account Section
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy'),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              // Handle sign out
            },
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Info'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppInfoScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () {
              // Show terms of service
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
