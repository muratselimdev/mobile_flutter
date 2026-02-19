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
    // API stores rating * 1000 (e.g. 4700 = 4.7 stars)
    final rawRating = _readDouble(map, ['rating', 'rate']) ?? 4800.0;
    final normalizedRating = rawRating > 100 ? rawRating / 1000.0 : rawRating;
    return PopularService(
      title: _readString(map, ['title', 'name', 'serviceName']) ?? '',
      provider: _readString(map, ['provider', 'clinic', 'clinicName']) ?? '',
      rating: double.parse(normalizedRating.toStringAsFixed(1)),
      reviews: _readInt(map, ['reviews', 'reviewCount']) ?? 0,
      price: _readPrice(map) ?? '',
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

  static String? _readPrice(Map<String, dynamic> map) {
    for (final key in ['price', 'cost', 'fee']) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) return value;
      if (value is num) {
        final intVal = value.toInt();
        // Format with thousands separator
        final str = intVal.toString();
        final buf = StringBuffer();
        for (int i = 0; i < str.length; i++) {
          if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
          buf.write(str[i]);
        }
        return buf.toString();
      }
    }
    return null;
  }
}
