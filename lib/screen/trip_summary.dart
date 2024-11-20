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
            buildRow('Distance Travel', '${getRandomValue(100, 100000)} km'),
            buildRow('Average Speed', '${getRandomValue(60, 150)} km/h'),
            buildRow('Top Speed', '${getRandomValue(100, 200)} km/h'),
            buildRow('Hours in Traffic',
                '${getRandomValue(2, 24)} hours ${getRandomValue(2, 60)} minutes'),
            buildRow('Idle Time',
                '${getRandomValue(2, 24)} hours ${getRandomValue(2, 60)} minutes'),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 20.0),
              child: Text('Trip Safety Matrix', style: headerStyle),
            ),
            buildRow('Over Speeding Incident', '${getRandomValue(2, 10)}'),
            buildRow('Sharp Turn', '${getRandomValue(2, 10)}'),
            buildRow('Rapid Acceleration', '${getRandomValue(2, 10)}'),
            buildRow('Harsh Breaking', '${getRandomValue(2, 10)}')
          ],
        ),
      ),
    );
  }
}
