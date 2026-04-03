//class for collected resident data upon signup

class ResidentData {
  //auth fields
  final String email;
  final String password;

  //personal info
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? suffix;
  final String phone;
  final DateTime birthdate;
  final String sex;

  //address
  final String? houseNo;
  final String? street;
  final String barangay;
  final String? municipality;
  final String city;
  final String province;
  final String region;
  final String? postalCode;
  final String? landmark;

  //household
  final int householdSize;
  final int children;
  final int elderly;
  final int disabled;
  final String? pets;

  //medical info
  final String? conditions;
  final String? history;
  final String? allergies;
  final String? medications;

  ResidentData({
    required this.email,
    required this.password,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.suffix,
    required this.phone,
    required this.birthdate,
    required this.sex,
    this.houseNo,
    this.street,
    this.barangay = "",
    this.municipality,
    required this.city,
    required this.province,
    required this.region,
    this.postalCode,
    this.landmark,
    this.householdSize = 1,
    this.children = 0,
    this.elderly = 0,
    this.disabled = 0,
    this.pets,
    this.conditions,
    this.history,
    this.allergies,
    this.medications,
  });

  factory ResidentData.fromJson(Map<String, dynamic> json) {
    return ResidentData(
      email: '',
      password: '',

      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'],
      lastName: json['last_name'] ?? '',
      suffix: json['suffix'],

      phone: json['phone'] ?? '',

      birthdate: DateTime.parse(json['birthdate']),
      sex: json['sex'] ?? 'male',

      houseNo: json['house_no'],
      street: json['street'],
      barangay: json['barangay'],
      municipality: json['municipality'],
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      region: json['region'] ?? '',
      postalCode: json['postal_code'],
      landmark: json['landmark'],

      householdSize: json['household_size'] ?? 1,
      children: json['children'] ?? 0,
      elderly: json['elderly'] ?? 0,
      disabled: json['disabled'] ?? 0,
      pets: json['pets'],

      conditions: json['conditions'],
      history: json['history'],
      allergies: json['allergies'],
      medications: json['medications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'suffix': suffix,
      'phone': phone,
      'birthdate': birthdate.toIso8601String().split('T')[0],
      'sex': sex,

      'house_no': houseNo,
      'street': street,
      'barangay': barangay,
      'municipality': municipality,
      'city': city,
      'province': province,
      'region': region,
      'postal_code': postalCode,
      'landmark': landmark,

      'household_size': householdSize,
      'children': children,
      'elderly': elderly,
      'disabled': disabled,
      'pets': pets,

      'conditions': conditions,
      'history': history,
      'allergies': allergies,
      'medications': medications,
    };
  }
}