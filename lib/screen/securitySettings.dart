import 'package:flutter/material.dart';

class SecuritySettingsPage extends StatefulWidget {
  @override
  _SecuritySettingsPageState createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool twoFactorAuth = false;

  void _showChangePasswordDialog() {
    String newPassword = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Enter New Password'),
              onChanged: (value) {
                newPassword = value;
              },
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newPassword.isNotEmpty) {
                // Handle password change logic here
                print('Password changed to: $newPassword');
              }
              Navigator.pop(context);
            },
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Track-Wise',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(45, 62, 80, 1),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color.fromRGBO(45, 62, 80, 1),
        child: ListView(
          children: [
            _buildSectionHeader('Password'),
            _buildButton('Change Password', _showChangePasswordDialog),
            SizedBox(height: 16),
            _buildSectionHeader('Two Factor Authentication'),
            _buildSwitchTile('Enable Two-Factor Authentication', twoFactorAuth,
                (value) {
              setState(() {
                twoFactorAuth = value;
              });
            }),
            SizedBox(height: 16),
            _buildSectionHeader('Login Activity'),
            _buildButton('Recent Logins', () {
              // Handle viewing recent login activity
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Recent Logins'),
                  content: Text('Login activity details coming soon.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            }),
            _buildButton('Logout All Devices', () {
              // Handle logout from all devices
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout All Devices'),
                  content: Text('Are you sure you want to logout from all devices?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement logout logic
                        print('Logged out from all devices');
                        Navigator.pop(context);
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
