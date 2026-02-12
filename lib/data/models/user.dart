class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? country;
  final int? languageGroupId;
  final String? languageCode;
  final String? profilePicture;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.country,
    this.languageGroupId,
    this.languageCode,
    this.profilePicture,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      country: json['country'] as String?,
      languageGroupId: json['languageGroupId'] as int?,
      languageCode: json['languageCode'] as String?,
      profilePicture: json['profilePicture'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'country': country,
      'languageGroupId': languageGroupId,
      'languageCode': languageCode,
      'profilePicture': profilePicture,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get initials {
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return '$first$last'.toUpperCase();
  }
}
