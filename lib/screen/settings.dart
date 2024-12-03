import 'package:flutter/material.dart';
import 'package:trackwise/screen/appInfo.dart';
import 'package:trackwise/screen/privacyPolicy.dart';
import 'dashboard.dart';
import 'profile_screen.dart';
import 'term_and_condition.dart';
import 'help_support.dart';
import '../services/auth_service.dart';
import 'login.dart';

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

  bool isPushNotificationsEnabled =
      false; // Separate state for push notifications
  bool isEmailNotificationsEnabled =
      false; // Separate state for email notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: const Color(0xFF2D3E50),
      ),
      body: Container(
        color: const Color(0xFF2D3E50),
        child: ListView(
          children: [
            // General Section
            _buildSectionHeader('General'),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title:
                  const Text('Language', style: TextStyle(color: Colors.white)),
              subtitle: Text(selectedLanguage,
                  style: const TextStyle(color: Colors.white70)),
              onTap: () {
                // Handle language selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white),
              title: const Text('Location Services',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Allow app to access location',
                  style: TextStyle(color: Colors.white70)),
              trailing: Switch(
                value: isLocationEnabled,
                onChanged: (value) {
                  setState(() {
                    isLocationEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            const Divider(color: Colors.white54),

            // Notifications Section
            _buildSectionHeader('Notifications'),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text('Push Notifications',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Enable notifications',
                  style: TextStyle(color: Colors.white70)),
              trailing: Switch(
                value: isPushNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    isPushNotificationsEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.white),
              title: const Text('Email Notifications',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Enable notifications',
                  style: TextStyle(color: Colors.white70)),
              trailing: Switch(
                value: isEmailNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    isEmailNotificationsEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            const Divider(color: Colors.white54),

            // Appearance Section
            _buildSectionHeader('Appearance'),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.white),
              title: const Text('Dark Mode',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(isDarkMode ? 'On' : 'Off',
                  style: const TextStyle(color: Colors.white70)),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields, color: Colors.white),
              title: const Text('Text Size',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Adjust text size',
                  style: TextStyle(color: Colors.white70)),
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
                  activeColor: Colors.blue,
                  inactiveColor: Colors.white54,
                ),
              ),
            ),
            const Divider(color: Colors.white54),

            // Account Section
            _buildSectionHeader('Account'),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title:
                  const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.white),
              title:
                  const Text('Privacy', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title:
                  const Text('Sign Out', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final authService =
                    AuthService(); // Initialize your auth service
                await authService.signOut(); // Call the sign-out function
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()), // Navigate to the login page
                );
              },
            ),
            const Divider(color: Colors.white54),

            // About Section
            _buildSectionHeader('About'),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title:
                  const Text('App Info', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppInfoScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.white),
              title: const Text('Terms of Service',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsAndConditionsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_center, color: Colors.white),
              title: const Text('Help & Support',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpSupportPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 0, 60, 110),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, // Set to 1 as this is the Settings screen
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
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
          color: Colors.white70,
        ),
      ),
    );
  }
}
