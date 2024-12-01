import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/profile_services.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  late UserProfile _userProfile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

 @override
void initState() {
  super.initState();

  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    setState(() {
      _nameController.text = user.displayName ?? ""; // If the name is available
      _emailController.text = user.email ?? "";      // Email of the logged-in user
      _phoneController.text = user.phoneNumber ?? ""; // If the phone number is linked
    });
  }
}


  void _saveProfile() async {
  User? user = FirebaseAuth.instance.currentUser;

  try {
    // Update Firebase user profile
    await user?.updateDisplayName(_nameController.text);
    await user?.updateEmail(_emailController.text);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bitmoji-style Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_userProfile.profilePictureUrl),
              backgroundColor: Colors.blue[600], // Color scheme match
            ),
            SizedBox(height: 16.0),
            // Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            // Phone Field
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            SizedBox(height: 16.0),
            // Address Field
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 32.0),
            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
