import 'package:flutter/material.dart';
//import 'dashboard_page.dart'; // Update with the correct import path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driving Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double drivingScore = 100.0;
  bool isTripActive = false;
  List<String> tripHistory = [];

  void _toggleTrip() {
    setState(() {
      isTripActive = !isTripActive;
      if (!isTripActive) {
        // When trip ends, add it to history
        tripHistory.add('Trip on ${DateTime.now().toString().substring(0, 16)} - Score: $drivingScore');
        // Reset score for next trip
        drivingScore = 100.0;
      }
    });
  }

  void _simulateScoreChange() {
    if (isTripActive) {
      setState(() {
        // Simulate score changes (replace with real scoring logic)
        drivingScore = drivingScore - (drivingScore > 50 ? 5 : 0);
      });
    }
  }

  Widget _buildDrivingScore() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              isTripActive ? 'Current Trip Score' : 'Last Trip Score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              drivingScore.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: drivingScore > 80 
                    ? Colors.green 
                    : drivingScore > 60 
                        ? const Color.fromARGB(255, 255, 255, 255) 
                        : const Color.fromARGB(255, 54, 162, 244),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripHistory() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (tripHistory.isEmpty)
              const Text('No trips recorded yet')
            else
              Column(
                children: tripHistory.reversed.map((trip) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(trip),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _toggleTrip,
        style: ElevatedButton.styleFrom(
          backgroundColor: isTripActive ? Colors.red : Colors.green,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          isTripActive ? 'End Trip' : 'Start New Trip',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDrivingMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetricCard('Trips\nCompleted', tripHistory.length.toString()),
        _buildMetricCard('Average\nScore', _calculateAverageScore()),
        _buildMetricCard('Best\nScore', _calculateBestScore()),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAverageScore() {
    if (tripHistory.isEmpty) return '0.0';
    double total = 0;
    for (String trip in tripHistory) {
      total += double.parse(trip.split('Score: ')[1]);
    }
    return (total / tripHistory.length).toStringAsFixed(1);
  }

  String _calculateBestScore() {
    if (tripHistory.isEmpty) return '0.0';
    double best = 0;
    for (String trip in tripHistory) {
      double score = double.parse(trip.split('Score: ')[1]);
      if (score > best) best = score;
    }
    return best.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Dashboard'),
        actions: [
          if (isTripActive)
            IconButton(
              icon: const Icon(Icons.casino),
              onPressed: _simulateScoreChange,
              tooltip: 'Simulate score change',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDrivingScore(),
            const SizedBox(height: 20),
            _buildDrivingMetrics(),
            const SizedBox(height: 20),
            _buildTripHistory(),
            const SizedBox(height: 20),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }
}
