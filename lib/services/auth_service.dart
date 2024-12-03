import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> registerUser(
      String email, String password, UserProfile userProfile) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Initialize the user's profile in Firestore
      final user = userCredential.user;

      if (user != null) {
        final userId = email; // Use email as the document ID

        // Reference to the user document
        final userRef = _firestore.collection('users').doc(userId);

        // Extract first and last name from displayName or set defaults
        String? displayName = user.displayName;
        String firstName = 'FirstName';
        String lastName = 'LastName';

        if (displayName != null && displayName.contains(' ')) {
          List<String> nameParts = displayName.split(' ');
          firstName = nameParts[0];
          lastName = nameParts.sublist(1).join(' ');
        } else if (displayName != null) {
          firstName = displayName; // Use full name as first name if no spaces
        }

        // Check if the document exists
        final docSnapshot = await userRef.get();

        if (docSnapshot.exists) {
          // Document exists, update only 'trip data' if needed
          final data = docSnapshot.data();
          if (data != null && data.containsKey('trip data')) {
            print('Field "trip data" already exists. Skipping addition.');
          } else {
            print('Field "trip data" does not exist. Adding it.');
            Map<String, String> tripData = _generateRandomFields();
            await userRef.set({
              'trip data': tripData,
            }, SetOptions(merge: true));
          }
        } else {
          // Document does not exist, create it with full fields
          print('Document does not exist. Creating it with trip data.');
          Map<String, String> tripData = _generateRandomFields();
          await userRef.set({
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'username': 'user${user.uid.substring(0, 6)}',
            'createdAt': FieldValue.serverTimestamp(),
            'trip data': tripData,
          });
        }
      }
    } catch (e) {
      throw e; // Handle error in UI layer
    }
  }

  Future<User?> signUpWithEmailPassword(
      String email, String password, UserProfile userProfile) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'firstName': userProfile.firstName,
          'lastName': userProfile.lastName,
          'username': userProfile.username,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw e; // Handle error in UI layer
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final userId = email; // Use email as the document ID

        // Reference to the user document
        final userRef = _firestore.collection('users').doc(userId);

        // Extract first and last name from displayName or set defaults
        String? displayName = user.displayName;
        String firstName = 'FirstName';
        String lastName = 'LastName';

        if (displayName != null && displayName.contains(' ')) {
          List<String> nameParts = displayName.split(' ');
          firstName = nameParts[0];
          lastName = nameParts.sublist(1).join(' ');
        } else if (displayName != null) {
          firstName = displayName; // Use full name as first name if no spaces
        }

        // Check if the document exists
        final docSnapshot = await userRef.get();

        if (docSnapshot.exists) {
          // Document exists, update only 'trip data' if needed
          final data = docSnapshot.data();
          if (data != null && data.containsKey('trip data')) {
            print('Field "trip data" already exists. Skipping addition.');
          } else {
            print('Field "trip data" does not exist. Adding it.');
            Map<String, String> tripData = _generateRandomFields();
            await userRef.set({
              'trip data': tripData,
            }, SetOptions(merge: true));
          }
        } else {
          // Document does not exist, create it with full fields
          print('Document does not exist. Creating it with trip data.');
          Map<String, String> tripData = _generateRandomFields();
          await userRef.set({
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'username': 'user${user.uid.substring(0, 6)}',
            'createdAt': FieldValue.serverTimestamp(),
            'trip data': tripData,
          });
        }
      }

      return user;
    } catch (e) {
      print('Error during sign-in: $e');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        final userRef = _firestore.collection('users').doc(user.uid);

        // Check if the user document exists
        final docSnapshot = await userRef.get();

        if (!docSnapshot.exists) {
          // Create a new document for the user
          await userRef.set({
            'email': user.email ?? '',
            'firstName':
                googleUser.displayName?.split(' ').first ?? 'FirstName',
            'lastName': googleUser.displayName?.split(' ').last ?? 'LastName',
            'username': 'google${user.uid.substring(0, 6)}',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<User?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        final userRef = _firestore.collection('users').doc(user.uid);

        final docSnapshot = await userRef.get();

        if (!docSnapshot.exists) {
          await userRef.set({
            'email': googleUser.email,
            'firstName':
                googleUser.displayName?.split(' ').first ?? 'FirstName',
            'lastName': googleUser.displayName?.split(' ').last ?? 'LastName',
            'username': 'google${user.uid.substring(0, 6)}',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      print("Error during Google Sign-Up: $e");
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> googlesignout() async {
    await _googleSignIn.signOut();
  }

  // Generate Random Fields
  Map<String, String> _generateRandomFields() {
    final random = Random();
    // Generate random durations
    final int days =
        random.nextInt(10 - 2 + 1) + 2; // Random number between 2 and 10
    final int hours =
        random.nextInt(24 - 2 + 1) + 2; // Random number between 2 and 10
    final int minutes =
        random.nextInt(59 - 2 + 1) + 2; // Random number between 2 and 10
    final int distanceTravel = Random().nextInt(10000 - 100 + 1) + 100;
    final int averageSpeed = Random().nextInt(150 - 60 + 1) + 60;
    final int topSpeed = Random().nextInt(200 - 100 + 1) + 100;
    final int trip_matrix = random.nextInt(10 - 2 + 1) + 2;
    return {
      'Time': '${days}days ${hours}hours ${minutes}minute',
      'distnceTravel': '${distanceTravel}',
      'averageSpeed': '${averageSpeed}',
      'topSpeed': '${topSpeed}',
      'HoursInTraffic': '${hours}hours ${minutes}minutes',
      'Idle': '${days}days ${hours}hours ${minutes}minute',
      'overSpeedingIncident': '${trip_matrix}',
      'sharpTurn': '${trip_matrix}',
      'rapidAcceleration ': '${trip_matrix}',
      'harshBreaking': '${trip_matrix}',
    };
  }

  Future<void> saveTripData() async {
    try {
      // Get the currently authenticated user
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      // Use the user's email as the document ID or fallback to UID
      final String userId = currentUser.email ?? currentUser.uid;

      // Generate random trip data
      final Map<String, String> tripData = _generateRandomFields();

      // Reference to the user document
      final userRef = _firestore.collection('users').doc(userId);

      // Ensure the user document exists
      await userRef.set({
        'email': userId,
        'name': currentUser.displayName ?? 'User Name',
      }, SetOptions(merge: true));

      // Add trip data to the 'trip' subcollection
      await userRef.collection('trip').add(tripData);
    } catch (e) {
      print('Error saving trip data: $e');
      rethrow;
    }
  }

// Existing function remains unchanged

  Future<List<Map<String, dynamic>>> fetchUserData(String documentId) async {
    try {
      // Reference to the Firestore document
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(documentId);

      // Get the document snapshot
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        // If the document exists, retrieve the trip data directly under the document
        final data = docSnapshot.data();
        if (data != null) {
          // Check if trip data is directly accessible
          if (data['trip data'] != null &&
              data['trip data'] is Map<String, dynamic>) {
            // Convert trip data map to a list with a single entry
            return [Map<String, dynamic>.from(data['trip data'])];
          } else {
            print('No trip data found for user $documentId.');
            return [];
          }
        } else {
          print('No data found for user $documentId.');
          return [];
        }
      } else {
        print('Document with ID $documentId does not exist.');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>?> fetchDetails(String userId) async {
    // Your logic to fetch user details from Firestore or any other database
    // Example:
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return snapshot.data();
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<void> saveDetails(
      String documentId, Map<String, dynamic> updatedData) async {
    try {
      // Reference to the Firestore document
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(documentId);

      // Update the document with the provided data
      await userRef.update(updatedData);

      print('User details updated successfully for $documentId.');
    } catch (e) {
      print('Error updating user details: $e');
      rethrow; // Re-throw the exception for further handling if needed
    }
  }

  // Handle user state changes
  Stream<User?> get user => _auth.authStateChanges();
}
