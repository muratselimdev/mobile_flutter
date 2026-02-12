import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String? country;
  final int? languageGroupId;

  const RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.country,
    this.languageGroupId,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    phoneNumber,
    country,
    languageGroupId,
  ];
}
