import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppSettingsPage extends StatefulWidget {
  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool locationAccess = true;
  bool dataSharing = false;
  bool parentalMonitoring = false;
  bool speedometerAccess = true;
  bool gyroscopeAccess = true;
  bool magnetometerAccess = true;
  bool microphoneAccess = true;

  String selectedLanguage = 'English';

  final Map<String, Map<String, String>> translations = {
    'English': {
      'privacy': 'Privacy',
      'location': 'Location',
      'dataSharing': 'Data Sharing',
      'parentalMonitoring': 'Enable Parental Monitoring',
      'sensorAccess': 'Sensor Access',
      'speedometer': 'Speedometer',
      'gyroscope': 'Gyros2cope',
      'magnetometer': 'Magnetometer',
      'microphone': 'Microphone',
      'language': 'Language',
      'deleteAccount': 'Delete Account',
      'appVersion': 'App Version',
    },
    'French': {
      'privacy': 'Confidentialité',
      'location': 'Emplacement',
      'dataSharing': 'Partage de Données',
      'parentalMonitoring': 'Activer le Contrôle Parental',
      'sensorAccess': 'Accès au Capteur',
      'speedometer': 'Compteur de Vitesse',
      'gyroscope': 'Gyroscope',
      'magnetometer': 'Magnétomètre',
      'microphone': 'Microphone',
      'language': 'Langue',
      'deleteAccount': 'Supprimer le Compte',
      'appVersion': 'Version de l’Application',
    },
  };

  String translate(String key) {
    return translations[selectedLanguage]?[key] ?? key;
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
            _buildSectionHeader(translate('privacy')),
            _buildSwitchTile(translate('location'), locationAccess, (value) {
              setState(() {
                locationAccess = value;
              });
            }),
            _buildSwitchTile(translate('dataSharing'), dataSharing, (value) {
              setState(() {
                dataSharing = value;
              });
            }),
            _buildSwitchTile(
                translate('parentalMonitoring'), parentalMonitoring, (value) {
              setState(() {
                parentalMonitoring = value;
              });
            }),
            _buildSectionHeader(translate('sensorAccess')),
            _buildSwitchTile(translate('speedometer'), speedometerAccess, (value) {
              setState(() {
                speedometerAccess = value;
              });
            }),
            _buildSwitchTile(translate('gyroscope'), gyroscopeAccess, (value) {
              setState(() {
                gyroscopeAccess = value;
              });
            }),
            _buildSwitchTile(
                translate('magnetometer'), magnetometerAccess, (value) {
              setState(() {
                magnetometerAccess = value;
              });
            }),
            _buildSwitchTile(translate('microphone'), microphoneAccess, (value) {
              setState(() {
                microphoneAccess = value;
              });
            }),
            
            _buildLanguageDropdown(),
            _buildDeleteAccountButton(),
            _buildAppVersion(),
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

  Widget _buildLanguageDropdown() {
    return ListTile(
      title: Text(
        translate('language'),
        style: TextStyle(color: Colors.white),
      ),
      trailing: DropdownButton<String>(
        value: selectedLanguage,
        dropdownColor: Color.fromRGBO(45, 62, 80, 1),
        items: translations.keys.map((String lang) {
          return DropdownMenuItem<String>(
            value: lang,
            child: Text(lang, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedLanguage = newValue!;
          });
        },
      ),
      
    );
  }

  Widget _buildDeleteAccountButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle delete account logic
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          );
        },
        child: Text(translate('deleteAccount')),
      ),
    );
  }

  Widget _buildAppVersion() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        '${translate('appVersion')}: 1.0.1',
        style: TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}

