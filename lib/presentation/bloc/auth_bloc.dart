import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/login_request.dart';
import '../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final loginRequest = LoginRequest(
        email: event.email,
        password: event.password,
      );

      final response = await authService.login(loginRequest);

      if (response.success) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            token: response.token,
            userData: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
