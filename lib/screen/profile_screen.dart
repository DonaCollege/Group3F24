import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/profile_services.dart';

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
    _userProfile = _profileService.getUserProfile();
    _nameController.text = _userProfile.name;
    _emailController.text = _userProfile.email;
    _phoneController.text = _userProfile.phone;
    _addressController.text = _userProfile.address; // Address added here
  }

  void _saveProfile() {
    UserProfile updatedProfile = UserProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      profilePictureUrl: _userProfile.profilePictureUrl, // Keep the same picture
      address: _addressController.text, // Save the address
    );

    _profileService.updateUserProfile(updatedProfile);
    setState(() {
      _userProfile = updatedProfile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
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
