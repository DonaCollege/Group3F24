class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String profilePictureUrl;
  final String address;  // New property for address

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePictureUrl,
    required this.address,  // Include address in the constructor
  });
}
