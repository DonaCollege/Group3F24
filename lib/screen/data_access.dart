import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataAccessScreen extends StatefulWidget {
  @override
  _DataAccessScreenState createState() => _DataAccessScreenState();
}

class _DataAccessScreenState extends State<DataAccessScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Placeholder user data
  String? userName;
  String? userEmail;

  Future<List<Map<String, dynamic>>> fetchTrips() async {
    List<Map<String, dynamic>> trips = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('trips').get();
      for (var doc in snapshot.docs) {
        trips.add({
          "destination": doc['destination'],
          "distance": doc['distance'],
          "date": doc['date'] ?? "N/A",
        });
      }
    } catch (e) {
      print("Error fetching trips: $e");
    }
    return trips;
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? "Anonymous User";
        userEmail = user.email ?? "No Email";
      });
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete the Firebase user
        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account deleted successfully.')),
        );

        // Redirect to Login Screen (replace with your LoginScreen widget)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
      print("Error deleting account: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Access"),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: const Color(0xFF2D3E50),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enlarged User Info Section
            Container(
              color: Colors.blue[100],
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Info",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  userName != null
                      ? Text(
                          "Name: $userName",
                          style: TextStyle(fontSize: 18),
                        )
                      : CircularProgressIndicator(),
                  SizedBox(height: 8),
                  userEmail != null
                      ? Text(
                          "Email: $userEmail",
                          style: TextStyle(fontSize: 18),
                        )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
            Divider(color: Colors.grey),

            // Trips Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Your Trips",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchTrips(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final trips = snapshot.data ?? [];
                  if (trips.isEmpty) {
                    return Center(child: Text("No trips available.", style: TextStyle(color: Colors.white)));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text("${trip['destination']}"),
                          subtitle: Text("Distance: ${trip['distance']} km"),
                          trailing: Text("${trip['date']}"),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Divider(color: Colors.grey),

            // Delete Account Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: deleteAccount,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Delete Account"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('Login Screen Placeholder'), // Replace with your actual Login UI
      ),
    );
  }
}
