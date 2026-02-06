class PopularService {
  final String title;
  final String provider;
  final double rating;
  final int reviews;
  final String price;
  final String imageUrl;

  const PopularService({
    required this.title,
    required this.provider,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageUrl,
  });

  factory PopularService.fromMap(Map<String, dynamic> map, {String? baseUrl}) {
    final rawImage =
        _readString(map, [
          'imageUrl',
          'image',
          'image_url',
          'imagePath',
          'photo',
          'thumbnail',
          'logo',
          'icon',
        ]) ??
        '';
    return PopularService(
      title: _readString(map, ['title', 'name', 'serviceName']) ?? '',
      provider: _readString(map, ['provider', 'clinic', 'clinicName']) ?? '',
      rating: _readDouble(map, ['rating', 'rate']) ?? 4.8,
      reviews: _readInt(map, ['reviews', 'reviewCount']) ?? 85,
      price: _readString(map, ['price', 'cost', 'fee']) ?? '',
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

  static double? _readDouble(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
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
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }
}
