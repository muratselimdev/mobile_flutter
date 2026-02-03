import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  static const String baseUrl = 'https://system.one-clinic.net:5001/api';

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/customer/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        // Handle error response
        final errorBody = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: errorBody['message']?.toString(),
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: null,
      );
    }
  }
}
