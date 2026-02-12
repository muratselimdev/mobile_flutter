class LanguageGroup {
  final int id;
  final String name;
  final String code;
  final bool isActive;

  LanguageGroup({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
  });

  factory LanguageGroup.fromJson(Map<String, dynamic> json) {
    return LanguageGroup(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'isActive': isActive};
  }
}
