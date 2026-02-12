class Category {
  final int id;
  final String name;
  final String? icon;
  final List<String> items;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.items = const [],
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];
    final List<String> itemsList;

    if (rawItems is List) {
      itemsList = rawItems.map((e) => e.toString()).toList();
    } else if (rawItems is String) {
      itemsList = [rawItems];
    } else {
      itemsList = [];
    }

    return Category(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String?,
      items: itemsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'icon': icon, 'items': items};
  }
}
