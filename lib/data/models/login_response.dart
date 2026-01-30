class LoginResponse {
  final bool success;
  final String? token;
  final String? message;
  final Map<String, dynamic>? data;

  LoginResponse({required this.success, this.token, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? true,
      token: json['token'],
      message: json['message'],
      data: json['data'],
    );
  }
}
