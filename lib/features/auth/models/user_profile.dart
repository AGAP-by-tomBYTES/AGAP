
class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String gender;
  final String address;
  final bool isVerified;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.isVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {

    if (json["email"] == null || (json["email"] as String).isEmpty) {
      throw Exception("Email is required.");
    }

    if (json["first_name"] == null || (json["first_name"] as String).isEmpty) {
      throw Exception("First name is required.");
    }

    if (json["last_name"] == null || (json["last_name"] as String).isEmpty) {
      throw Exception("Last name is required.");
    }

    if (json["gender"] == null || (json["gender"] as String).isEmpty) {
      throw Exception("Gender is required.");
    }

    if (json["address"] == null || (json["address"] as String).isEmpty) {
      throw Exception("Address is required.");
    }

    return UserProfile(
      id: json["id"] as String,
      email: json["email"] as String,
      firstName: json["first_name"] as String,
      middleName: json["middle_name"] as String? ?? "",
      lastName: json["last_name"] as String,
      gender: json["gender"] as String,
      address: json["address"] as String,
      isVerified: json["is_verified"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'address': address,
      'is_verified': isVerified,
    };
  }
}