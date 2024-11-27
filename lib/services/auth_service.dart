import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add this import
import '../models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Initialize Firestore
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Initialize GoogleSignIn

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

  // Register user with email and password
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

  // Update user profile
  Future<void> updateUserProfile(
      String userId, UserProfile updatedProfile) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': updatedProfile.name,
        'phone': updatedProfile.phone,
        'address': updatedProfile.address,
        'profilePictureUrl': updatedProfile.profilePictureUrl,
      });
    } catch (e) {
      throw e; // Handle error in UI layer
    }
  }

  // Handle user login (you can use this method for sign-in functionality)
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      throw e.message!;
    }
  }

  // Handle sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle user state changes
  Stream<User?> get user => _auth.authStateChanges();
}
