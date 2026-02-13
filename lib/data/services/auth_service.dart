import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthService {
  static const String baseUrl = 'https://system.one-clinic.net:5001/api';

  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/customer/auth/register');

      developer.log('Registration Request URL: $url');
      developer.log(
        'Registration Request Body: ${jsonEncode(request.toJson())}',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      developer.log('Registration Response Status: ${response.statusCode}');
      developer.log('Registration Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        // Handle error response
        try {
          final errorBody = jsonDecode(response.body);
          final errorMessage =
              errorBody['message']?.toString() ??
              errorBody['error']?.toString() ??
              'Registration failed';
          developer.log('Registration Error: $errorMessage');
          return LoginResponse(success: false, message: errorMessage);
        } catch (e) {
          developer.log('Error parsing error response: $e');
          return LoginResponse(
            success: false,
            message: 'Registration failed: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      developer.log('Registration Exception: $e');
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/customer/auth/login');

      developer.log('Login Request URL: $url');
      developer.log('Login Request Body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      developer.log('Login Response Status: ${response.statusCode}');
      developer.log('Login Response Body: ${response.body}');

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
      developer.log('Login Exception: $e');
      return LoginResponse(success: false, message: null);
    }
  }

  Future<bool> logout(String? token) async {
    try {
      final url = Uri.parse('$baseUrl/customer/auth/logout');

      developer.log('Logout Request URL: $url');
      developer.log(
        'Logout Request Token: ${token != null ? "Token present" : "No token"}',
      );

      final headers = <String, String>{'Content-Type': 'application/json'};

      // Add authorization header if token exists
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(url, headers: headers);

      developer.log('Logout Response Status: ${response.statusCode}');
      developer.log('Logout Response Body: ${response.body}');

      // Consider 200, 201, and 401 as successful logout
      // 401 means token already invalid, which is fine for logout
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 401) {
        return true;
      } else {
        developer.log('Logout failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      developer.log('Logout Exception: $e');
      // Return true even on exception to ensure user is logged out locally
      return true;
    }
  }
}
