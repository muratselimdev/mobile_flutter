import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/language_group.dart';

class LanguageGroupService {
  static const String baseUrl = 'https://system.one-clinic.net:5001/api';

  Future<List<LanguageGroup>> fetchLanguageGroups() async {
    try {
      final url = Uri.parse('$baseUrl/admin/language-groups?isActive=true');

      print('Fetching language groups from: $url');

      final response = await http.get(url);

      print('Language Groups Response Status: ${response.statusCode}');
      print('Language Groups Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<dynamic> languagesList;
        if (decoded is List) {
          languagesList = decoded;
        } else if (decoded is Map<String, dynamic>) {
          // Try common keys for the list
          languagesList =
              decoded['data'] as List? ??
              decoded['items'] as List? ??
              decoded['result'] as List? ??
              decoded['languageGroups'] as List? ??
              [];
        } else {
          languagesList = [];
        }

        return languagesList
            .map((json) => LanguageGroup.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('Failed to load language groups: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching language groups: $e');
      return [];
    }
  }
}
