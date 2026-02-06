import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/campaign.dart';

class CampaignApi {
  CampaignApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Campaign>> fetchCampaigns() async {
    final uri = Uri.parse(
      'https://system.one-clinic.net:5001/api/admin/campaigns',
    );
    final response = await _client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch campaigns');
    }

    final decoded = json.decode(response.body);
    final list = _extractList(decoded);
    final baseUrl = uri.origin;
    return list
        .whereType<Map>()
        .map(
          (item) => Campaign.fromMap(
            Map<String, dynamic>.from(item),
            baseUrl: baseUrl,
          ),
        )
        .where((item) => item.description.trim().isNotEmpty)
        .toList();
  }

  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) {
      return decoded;
    }
    if (decoded is Map<String, dynamic>) {
      final candidates = [
        decoded['data'],
        decoded['items'],
        decoded['result'],
        decoded['campaigns'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate;
        }
      }
    }
    return const <dynamic>[];
  }
}
