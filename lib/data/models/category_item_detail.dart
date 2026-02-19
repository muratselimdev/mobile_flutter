class CategoryItemDetail {
  final int id;
  final int categoryItemId;
  final String label;
  final String detail;
  final String imageUrl;
  final String videoUrl;
  final String createdAt;
  final bool isActive;

  const CategoryItemDetail({
    required this.id,
    required this.categoryItemId,
    required this.label,
    required this.detail,
    required this.imageUrl,
    required this.videoUrl,
    required this.createdAt,
    required this.isActive,
  });

  factory CategoryItemDetail.fromMap(Map<String, dynamic> map) {
    return CategoryItemDetail(
      id: map['id'] as int? ?? 0,
      categoryItemId: map['categoryItemId'] as int? ?? 0,
      label: map['label']?.toString() ?? '',
      detail: map['detail']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      videoUrl: map['videoUrl']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? '',
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
