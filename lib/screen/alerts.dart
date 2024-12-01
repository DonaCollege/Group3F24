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
      title: 'Real-Time Alerts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AlertsPage(),
    );
  }
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<Alert> alerts = [
    Alert(
      title: 'Speed Limit Exceeded',
      message: 'You are exceeding the speed limit of 60 km/h.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Alert(
      title: 'Unsafe Driving',
      message: 'Please slow down. You are driving too fast for conditions.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Alert(
      title: 'Seatbelt Reminder',
      message: 'Please fasten your seatbelt.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Alerts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Recent Alerts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (alerts.isEmpty)
              const Center(child: Text('No alerts at the moment.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return _buildAlertCard(alerts[index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              alert.message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTimestamp(alert.timestamp),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')} - ${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

class Alert {
  final String title;
  final String message;
  final DateTime timestamp;

  Alert({required this.title, required this.message, required this.timestamp});
}
