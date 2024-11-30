import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class TripSummary extends StatefulWidget {
  @override
  _TripSummaryState createState() => _TripSummaryState();
}

class _TripSummaryState extends State<TripSummary> {
  final AuthService _authService = AuthService();
  late Future<List<Map<String, dynamic>>> _tripSummariesFuture;
  late String _userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.email!; // Use the user's email as the document ID
      _tripSummariesFuture = _authService.fetchUserData(_userId);
    } else {
      throw Exception("User not logged in");
    }
  }

  Widget buildTripCard(Map<String, dynamic> tripData) {
    return Card(
      color: const Color(0xFF2A3A4A),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip on ${tripData['Time']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            buildRow('Distance Travel', '${tripData['distnceTravel']} km'),
            buildRow('Average Speed', '${tripData['averageSpeed']} km/h'),
            buildRow('Top Speed', '${tripData['topSpeed']} km/h'),
            buildRow('Hours in Traffic', '${tripData['HoursInTraffic']}'),
            buildRow('Idle Time', '${tripData['Idle']}'),
            const SizedBox(height: 10),
            Text(
              'Safety Metrics:',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            buildRow('Over Speeding Incidents',
                '${tripData['overSpeedingIncident']}'),
            buildRow('Sharp Turns', '${tripData['sharpTurn']}'),
            buildRow('Rapid Accelerations', '${tripData['rapidAcceleration']}'),
            buildRow('Harsh Brakings', '${tripData['harshBreaking']}'),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A38),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A3A4A),
        title: const Text('Trip Summary'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tripSummariesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            final trips = snapshot.data!;
            if (trips.isEmpty) {
              return Center(
                child: Text(
                  'No trip data available. Save a trip to get started!',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return buildTripCard(trips[index]);
              },
            );
          } else {
            return Center(
              child: Text(
                'Something went wrong. Try again later.',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
