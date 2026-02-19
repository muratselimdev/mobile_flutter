import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_item.dart';
import '../models/category_item_detail.dart';

class CategoryItemApi {
  static const String _baseUrl =
      'https://system.one-clinic.net:5001/api/mobile/home';

  CategoryItemApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<CategoryItem>> fetchCategoryItems(int categoryId) async {
    final uri = Uri.parse(_baseUrl);
    final response = await _client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch category items');
    }
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final rawList = decoded['categoryItems'];
    if (rawList is! List) return [];
    return rawList
        .whereType<Map>()
        .map((m) => CategoryItem.fromMap(Map<String, dynamic>.from(m)))
        .where((item) => item.categoryId == categoryId)
        .toList();
  }

  Future<List<CategoryItemDetail>> fetchCategoryItemDetails(
    int categoryItemId,
  ) async {
    final uri = Uri.parse(_baseUrl);
    final response = await _client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch category item details');
    }
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final rawList = decoded['categoryItemDetails'];
    if (rawList is! List) return [];
    return rawList
        .whereType<Map>()
        .map((m) => CategoryItemDetail.fromMap(Map<String, dynamic>.from(m)))
        .where((d) => d.categoryItemId == categoryItemId)
        .toList();
  }
}
