import '../models/user_profile.dart';

class AuthService {
  void registerUser(UserProfile user) {
    print('Registering user:');
    print('Name: ${user.name}');
    print('Email: ${user.email}');
    print('Phone: ${user.phone}');
    print('Address: ${user.address}');
    print('Profile Picture URL: ${user.profilePictureUrl}');
    // Add backend logic here
  }
}
