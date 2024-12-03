import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackwise/screen/map.dart';
import 'package:trackwise/screen/trip_summary.dart';
import 'settings.dart';
import 'profile_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double drivingScore = 30.0;
  bool isTripActive = false;
  DateTime? tripStartTime;
  List<String> warnings = [
    'Over Speeding near Wonderland Exit 401',
    'Harsh Brake Detected',
    'Late Night Driving Patterns'
  ];
  SharedPreferences? _prefs;
  int _currentIndex = 0; // Track the selected index for the bottom navigation

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _checkLocationPermission();

    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1F2937),
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTripState();
  }

  void _loadTripState() {
    if (_prefs != null) {
      setState(() {
        isTripActive = _prefs!.getBool('isTripActive') ?? false;
        final savedStartTime = _prefs!.getString('tripStartTime');
        if (savedStartTime != null) {
          tripStartTime = DateTime.parse(savedStartTime);
        }
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showMessage('Location permissions are permanently denied');
      return;
    }
  }

  void calculateDrivingScore({
    required double speed,
    required double acceleration,
    required double braking,
  }) {
    setState(() {
      double score = 100.0;

      if (speed > 80) score -= (speed - 80) * 0.5;
      if (acceleration > 2.5) score -= (acceleration - 2.5) * 5;
      if (braking > 3.0) score -= (braking - 3.0) * 5;

      drivingScore = score.clamp(0.0, 100.0);
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleTrip() {
    setState(() {
      isTripActive = !isTripActive;
      tripStartTime = isTripActive ? DateTime.now() : null;
      if (_prefs != null) {
        _prefs!.setBool('isTripActive', isTripActive);
        if (tripStartTime != null) {
          _prefs!.setString('tripStartTime', tripStartTime!.toIso8601String());
        }
      }
    });
  }

  String _formatTripDuration() {
    if (tripStartTime == null) return '0h 0m 0s';
    final difference = DateTime.now().difference(tripStartTime!);
    return '${difference.inHours}h ${difference.inMinutes % 60}m ${difference.inSeconds % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1F2937), Color(0xFF111827)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Driving Score',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(200, 200),
                        painter: GaugePainter(score: drivingScore),
                      ),
                      Column(
                        children: [
                          Text(
                            '${drivingScore.toInt()}/100',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatTripDuration(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavButton(
                      icon: Icons.map_outlined,
                      label: 'Map',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                      },
                    ),
                    _buildNavButton(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TripSummary()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Warnings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...warnings.map((warning) => Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  warning,
                                  style: TextStyle(
                                    color: Colors.red.shade300,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _toggleTrip,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: isTripActive ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isTripActive ? 'End Trip' : 'Start Trip',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 60, 110),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex, // Adjust to set Dashboard as selected
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
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
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double score;

  GaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background arc
    paint.color = Colors.grey.withOpacity(0.3);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Foreground arc
    paint.color = _getScoreColor();
    final sweepAngle = math.pi * (score / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      paint,
    );
  }

  Color _getScoreColor() {
    if (score >= 80) return Colors.green;
    if (score >= 50) return Colors.yellow;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
