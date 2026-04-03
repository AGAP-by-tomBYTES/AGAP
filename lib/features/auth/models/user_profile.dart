class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String gender;
  final String address;
  final bool isVerified;
  final bool isResponder;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.isVerified,
    required this.isResponder,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {

    return UserProfile(
      id: json["id"] as String,
      email: json["email"] as String? ?? "",
      firstName: json["first_name"] as String? ?? "",
      middleName: json["middle_name"] as String?,
      lastName: json["last_name"] as String? ?? "",
      gender: json["gender"] as String? ?? "",
      address: json["address"] as String? ?? "",
      isVerified: json["is_verified"] as bool? ?? false,
      isResponder: json["is_responder"] as bool? ?? false,
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
      'is_responder': isResponder,
    };
  }

  UserProfile copyWith({
    String? email,
    String? firstName,
    String? middleName,
    String? lastName,
    String? gender,
    String? address,
    bool? isVerified,
    bool? isResponder,
  }) {
    return UserProfile(
      id: id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
      isResponder: isResponder ?? this.isResponder,
    );
  }

  String get fullName {
    if (middleName != null && middleName!.isNotEmpty) {
      return '$firstName $middleName $lastName';
    }
    return '$firstName $lastName';
  }
}