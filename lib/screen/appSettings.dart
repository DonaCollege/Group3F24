import 'package:flutter/material.dart';
import 'privacyPolicy.dart';
import 'appInfo.dart';

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
      'gyroscope': 'Gyroscope',
      'magnetometer': 'Magnetometer',
      'microphone': 'Microphone',
      'language': 'Language',
      'deleteAccount': 'Delete Account',
      'appVersion': 'App Version',
      'privacyPolicy': 'Privacy Policy',
      'appInfo': 'App Info',
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
      'privacyPolicy': 'Politique de Confidentialité',
      'appInfo': 'Informations sur l’Application',
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
            _buildSwitchTile(translate('parentalMonitoring'), parentalMonitoring, (value) {
              setState(() {
                parentalMonitoring = value;
              });
            }),
            _buildListTile(translate('privacyPolicy'), PrivacyPolicyScreen()),
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
            _buildSwitchTile(translate('magnetometer'), magnetometerAccess, (value) {
              setState(() {
                magnetometerAccess = value;
              });
            }),
            _buildSwitchTile(translate('microphone'), microphoneAccess, (value) {
              setState(() {
                microphoneAccess = value;
              });
            }),
            _buildListTile(translate('appInfo'), AppInfoScreen()),
            _buildLanguageDropdown(),
            _buildDeleteAccountButton(),
            _buildAppVersion(),
          ],
        ),
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

  Widget _buildListTile(String title, Widget screen) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.arrow_forward, color: Colors.white),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
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
