import 'user.dart';

class LoginResponse {
  final bool success;
  final String? token;
  final String? message;
  final Map<String, dynamic>? data;
  final User? user;

  LoginResponse({
    required this.success,
    this.token,
    this.message,
    this.data,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    User? user;

    // Try to parse user from different possible locations in the response
    if (json['profile'] != null) {
      // Backend returns user data in 'profile' field
      user = User.fromJson(json['profile'] as Map<String, dynamic>);
    } else if (json['user'] != null) {
      user = User.fromJson(json['user'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['user'] != null) {
        user = User.fromJson(dataMap['user'] as Map<String, dynamic>);
      } else if (dataMap['profile'] != null) {
        user = User.fromJson(dataMap['profile'] as Map<String, dynamic>);
      } else {
        // If data itself contains user fields, treat it as user
        user = User.fromJson(dataMap);
      }
    }

    return LoginResponse(
      success: json['success'] ?? true,
      token: json['token'] ?? json['data']?['token'],
      message: json['message'],
      data: json['data'],
      user: user,
    );
  }
}
