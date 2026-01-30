import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;
  final Map<String, dynamic>? userData;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.errorMessage,
    this.userData,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? errorMessage,
    Map<String, dynamic>? userData,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [status, token, errorMessage, userData];
}
