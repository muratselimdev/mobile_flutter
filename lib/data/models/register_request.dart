class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String country;
  final int languageGroupId;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.country,
    this.languageGroupId = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'country': country,
      'languageGroupId': languageGroupId,
    };
  }
}
