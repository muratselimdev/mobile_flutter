import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final request = RegisterRequest(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        phone: event.phoneNumber,
        country: event.country ?? 'TR',
        languageGroupId: event.languageGroupId ?? 0,
      );

      final response = await authService.register(request);

      if (response.success) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            token: response.token,
            userData: response.data,
            user: response.user,
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
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
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
            user: response.user,
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
      emit(state.copyWith(status: AuthStatus.error, errorMessage: null));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Call backend logout API to delete tokens
      final token = state.token;
      if (token != null && token.isNotEmpty) {
        await authService.logout(token);
      }
    } catch (e) {
      print('Error during logout: $e');
      // Continue with logout even if API call fails
    }

    // Clear local auth state
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
