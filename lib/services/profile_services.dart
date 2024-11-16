import '../models/user_profile.dart';

class ProfileService {
  // Simulated user profile data
  UserProfile getUserProfile() {
    return UserProfile(
      name: 'Dona Barot',
      email: 'barotdona@example.com',
      phone: '+1234567890',
      profilePictureUrl:
          'https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg', // Placeholder profile picture
      address: '123 Main St, Waterloo, Canada', // Address added here
    );
  }

  void updateUserProfile(UserProfile updatedProfile) {
    // Simulate saving the updated profile
    print(
        'Profile updated: ${updatedProfile.name}, ${updatedProfile.email}, ${updatedProfile.phone}, ${updatedProfile.address}');
  }
}
