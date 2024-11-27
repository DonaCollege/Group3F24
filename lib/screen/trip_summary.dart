import 'package:flutter/material.dart';
import 'dart:math';

class TripSummary extends StatelessWidget {
  final Color backgroundColor = const Color(0xFF2A3A4A);
  final TextStyle titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  final TextStyle valueStyle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  final int distanceTravel = Random().nextInt(100000 - 100 + 1) + 100;
  final int averageSpeed = Random().nextInt(150 - 60 + 1) + 60;
  final int topSpeed = Random().nextInt(200 - 100 + 1) + 100;
  final int hoursInTrafficHours = Random().nextInt(24 - 2 + 1) + 2;
  final int hoursInTrafficMinutes = Random().nextInt(60 - 2 + 1) + 2;
  final int idleTimeHours = Random().nextInt(24 - 2 + 1) + 2;
  final int idleTimeMinutes = Random().nextInt(60 - 2 + 1) + 2;
  final int overSpeedingIncident = Random().nextInt(10 - 2 + 1) + 2;
  final int sharpTurn = Random().nextInt(10 - 2 + 1) + 2;
  final int rapidAcceleration = Random().nextInt(10 - 2 + 1) + 2;
  final int harshBreaking = Random().nextInt(10 - 2 + 1) + 2;

  int getRandomValue(int min, int max) => Random().nextInt(max - min + 1) + min;

  Widget buildRow(String title, String value, {bool isLargeHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isLargeHeader ? headerStyle : titleStyle,
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Track-Wise',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Trip Summary', style: headerStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 5.0),
              child: Text(
                '${getRandomValue(2, 10)} days ${getRandomValue(2, 24)} hours ${getRandomValue(2, 60)} minutes',
                style: valueStyle.copyWith(fontSize: 16),
              ),
            ),
            buildRow('Distance Travel', '$distanceTravel km'),
            buildRow('Average Speed', '$averageSpeed km/h'),
            buildRow('Top Speed', '$topSpeed km/h'),
            buildRow(
              'Hours in Traffic',
              '$hoursInTrafficHours hours $hoursInTrafficMinutes minutes',
            ),
            buildRow(
              'Idle Time',
              '$idleTimeHours hours $idleTimeMinutes minutes',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 20.0),
              child: Text('Trip Safety Matrix', style: headerStyle),
            ),
            buildRow('Over Speeding Incident', '$overSpeedingIncident'),
            buildRow('Sharp Turn', '$sharpTurn'),
            buildRow('Rapid Acceleration', '$rapidAcceleration'),
            buildRow('Harsh Breaking', '$harshBreaking'),
          ],
        ),
      ),
    );
  }
}
