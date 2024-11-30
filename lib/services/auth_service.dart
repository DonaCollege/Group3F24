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
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': userProfile.name,
        'email': email, // Email is already available
        'createdAt': FieldValue.serverTimestamp(), // Track creation time
      });
    } catch (e) {
      throw e; // Handle error in UI layer
    }
  }

  // Email and Password Sign-Up
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
        await _firestore.collection('users').doc(user.email).set({
          'name': userProfile.name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          ..._generateRandomFields(),
        });
      }

      return user;
    } catch (e) {
      throw e; // Handle error in UI layer
    }
  }

  // Email and Password Sign-In
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final userId =
            user.email ?? user.uid; // Use email as document ID, fallback to UID

        // Reference to the user document
        final userRef = _firestore.collection('users').doc(userId);

        // Check if the document exists
        final docSnapshot = await userRef.get();

        if (docSnapshot.exists) {
          // Document exists, check if 'trip data' field exists
          final data = docSnapshot.data();
          if (data != null && data.containsKey('trip data')) {
            print('Field "trip data" already exists. Skipping addition.');
          } else {
            print('Field "trip data" does not exist. Adding it.');
            Map<String, String> tripData = _generateRandomFields();
            await userRef.set({
              'email': userId,
              'name': user.displayName ?? 'User Name',
              'trip data': tripData,
            }, SetOptions(merge: true));
          }
        } else {
          // Document does not exist, create it with trip data
          print('Document does not exist. Creating it with trip data.');
          Map<String, String> tripData = _generateRandomFields();
          await userRef.set({
            'email': userId,
            'name': user.displayName ?? 'User Name',
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

  // Google Sign-In method
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google authentication details
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Return the user
      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<User?> signUpWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google authentication details
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if the user already exists in Firebase Authentication
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        // If the user does not exist, create a new user
        UserCredential newUserCredential =
            await _auth.signInWithCredential(credential);

        // Create a user profile object
        final userProfile = UserProfile(
          name: googleUser.displayName ?? "No Name",
          email: googleUser.email,
          phone: '', // Add input for phone if required
          address: '', // Add input for address if required
          profilePictureUrl:
              googleUser.photoUrl ?? '', // Add URL input if needed
        );

        // Store the user profile in Firestore
        await _firestore
            .collection('users')
            .doc(newUserCredential.user?.uid)
            .set({
          'name': userProfile.name,
          'email': googleUser.email,
          'phone': userProfile.phone,
          'address': userProfile.address,
          'profilePictureUrl': userProfile.profilePictureUrl,
          'createdAt': FieldValue.serverTimestamp(), // Track creation time
        });
      }

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-Up: $e");
      return null;
    }
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e; // Handle error in UI layer
    }
  }

  // Sign-Out
  Future<void> signOut() async {
    await _auth.signOut();
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

  Future<void> saveTripData({required String userId}) async {
    try {
      // Generate random trip data
      final Map<String, String> tripData = _generateRandomFields();

      // Save user data under the 'users' collection and 'trip' subcollection
      final userRef = _firestore.collection('users').doc(userId);

      // Check if the user document exists, if not create it
      await userRef.set({
        'email': userId, // Store email as document ID or in the fields
        'name':
            'User Name', // You can replace this with actual user name if available
      }, SetOptions(merge: true));

      // Add trip data to the 'trip' subcollection
      await userRef.collection('trip').add(tripData);
    } catch (e) {
      rethrow;
    }
  }

  // Fetch trip summaries for the user
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

  // Handle user state changes
  Stream<User?> get user => _auth.authStateChanges();
}
