class CategoryItem {
  final int id;
  final int categoryId;
  final String name;
  final String createdAt;
  final bool isActive;

  const CategoryItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      id: map['id'] as int? ?? 0,
      categoryId: map['categoryId'] as int? ?? 0,
      name: map['name']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? '',
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
