class Campaign {
  final String title;
  final String description;
  final int discountRate;
  final String imageUrl;

  const Campaign({
    required this.title,
    required this.description,
    required this.discountRate,
    required this.imageUrl,
  });

  factory Campaign.fromMap(Map<String, dynamic> map, {String? baseUrl}) {
    final rawImage =
        _readString(map, [
          'imageUrl',
          'image',
          'image_url',
          'imagePath',
          'photo',
          'thumbnail',
          'banner',
        ]) ??
        '';
    return Campaign(
      title: _readString(map, ['title', 'name']) ?? '',
      description: _readString(map, ['description', 'detail']) ?? '',
      discountRate:
          _readInt(map, ['discountRate', 'discount', 'rate', 'percent']) ?? 0,
      imageUrl: _normalizeImageUrl(rawImage, baseUrl: baseUrl),
    );
  }

  static String _normalizeImageUrl(String value, {String? baseUrl}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('//')) {
      return 'https:$trimmed';
    }
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return trimmed;
    }
    final baseUri = Uri.parse(baseUrl);
    return baseUri.resolve(trimmed).toString();
  }

  static String? _readString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static int? _readInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = int.tryParse(value.replaceAll('%', '').trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }
}
