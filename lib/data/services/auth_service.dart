import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthService {
  static const String baseUrl = 'https://system.one-clinic.net:5001/api';

  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/customer/auth/register');

      print('Registration Request URL: $url');
      print('Registration Request Body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Registration Response Status: ${response.statusCode}');
      print('Registration Response Body: ${response.body}');

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
          print('Registration Error: $errorMessage');
          return LoginResponse(success: false, message: errorMessage);
        } catch (e) {
          print('Error parsing error response: $e');
          return LoginResponse(
            success: false,
            message: 'Registration failed: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      print('Registration Exception: $e');
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/customer/auth/login');

      print('Login Request URL: $url');
      print('Login Request Body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

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
      print('Login Exception: $e');
      return LoginResponse(success: false, message: null);
    }
  }
}
