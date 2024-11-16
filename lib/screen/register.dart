import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(); // New phone field
  final TextEditingController _addressController =
      TextEditingController(); // New address field
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A3A4A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Track-Wise',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                _buildInputField(_emailController, 'Enter your Email'),
                SizedBox(height: 15),
                _buildInputField(_nameController, 'Enter the Username'),
                SizedBox(height: 15),
                _buildInputField(_phoneController, 'Enter your Phone Number'),
                SizedBox(height: 15),
                _buildInputField(_addressController, 'Enter your Address'),
                SizedBox(height: 15),
                _buildInputField(_passwordController, 'Enter the Password',
                    obscureText: true),
                SizedBox(height: 15),
                _buildInputField(
                    _confirmPasswordController, 'Re-enter Password',
                    obscureText: true),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    // Validate input
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      final user = UserProfile(
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        profilePictureUrl: '', // Default value for now
                      );
                      _authService.registerUser(user);
                    } else {
                      print('Passwords do not match');
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[700],
        hintStyle: TextStyle(color: Colors.grey[300]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
