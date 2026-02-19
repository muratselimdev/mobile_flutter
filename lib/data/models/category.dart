class Category {
  final int id;
  final String name;
  final String? icon;
  final String description;
  final bool isActive;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.description = '',
    this.isActive = true,
    this.createdAt = '',
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String?,
      description: map['description'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
