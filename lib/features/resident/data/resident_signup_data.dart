class ResidentSignupData {
  String email;
  String password;
  String firstName;
  String? middleName;
  String lastName;
  String? suffix;
  String phone;
  String birthdate;
  String gender;

  // Location
  String? houseNo;
  String street;
  String barangay;
  String municipality;
  String city;
  String province;
  String postalCode;
  String? landmark;

  // Household
  int householdSize = 1;
  int children = 0;
  int elderly = 0;
  int disabled = 0;
  String? pets;

  // Medical
  String? conditions;
  String? history;
  String? allergies;
  String? medications;

  ResidentSignupData({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.middleName,
    this.suffix,
    required this.birthdate,
    required this.gender,
    this.barangay = '',
    this.street = '',
    this.city = '',
    this.houseNo,
    this.municipality = '', 
    this.province = '',
    this.postalCode = '',
    this.landmark,
  });
}