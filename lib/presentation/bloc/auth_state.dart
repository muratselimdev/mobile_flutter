import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;
  final Map<String, dynamic>? userData;
  final User? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.errorMessage,
    this.userData,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? errorMessage,
    Map<String, dynamic>? userData,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, token, errorMessage, userData, user];
}
