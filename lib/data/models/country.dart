class Country {
  final String name;
  final String code; // ISO 3166-1 alpha-2
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String,
      code: json['code'] as String,
      dialCode: json['dial_code'] as String,
      flag: json['flag'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code, 'dial_code': dialCode, 'flag': flag};
  }

  @override
  String toString() => '$flag $name ($dialCode)';
}
