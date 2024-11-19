import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A3A4A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Track-Wise',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputField(_emailController, 'Enter your Email'),
                const SizedBox(height: 15),
                _buildInputField(_nameController, 'Enter the Username'),
                const SizedBox(height: 15),
                _buildInputField(_passwordController, 'Enter the Password',
                    obscureText: true),
                const SizedBox(height: 15),
                _buildInputField(
                    _confirmPasswordController, 'Re-enter Password',
                    obscureText: true),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15),
                  ),
                  onPressed: () {
                    // Validate input
                    if (_emailController.text.isEmpty) {
                      _showSnackBar(context, 'Email is required');
                      return;
                    }
                    if (_nameController.text.isEmpty) {
                      _showSnackBar(context, 'Username is required');
                      return;
                    }
                    if (_passwordController.text.isEmpty) {
                      _showSnackBar(context, 'Password is required');
                      return;
                    }
                    if (_confirmPasswordController.text.isEmpty) {
                      _showSnackBar(context, 'Please confirm your password');
                      return;
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      _showSnackBar(context, 'Passwords do not match');
                      return;
                    }

                    // Create user if all fields are valid
                    final user = UserProfile(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: '', // Placeholder, adjust if needed
                      address: '', // Placeholder, adjust if needed
                      profilePictureUrl: '',
                    );
                    _authService.registerUser(user);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Or',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                _buildSocialButton('Sign up with Google', Colors.white,
                    'lib/assets/google_icon.png'),
                const SizedBox(height: 10),
                _buildSocialButton('Sign up with Facebook', Colors.white,
                    'lib/assets/facebook_icon.png'),
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
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[600],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSocialButton(String text, Color color, String iconPath) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {},
      icon: Image.asset(
        iconPath,
        width: 24,
        height: 24,
      ),
      label: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
