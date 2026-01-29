part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingLoaded extends OnboardingState {
  final String currentLanguage;

  const OnboardingLoaded({required this.currentLanguage});

  @override
  List<Object> get props => [currentLanguage];
}

class NavigateToSignInState extends OnboardingState {
  const NavigateToSignInState();
}

class NavigateToCreateAccountState extends OnboardingState {
  const NavigateToCreateAccountState();
}

class OnboardingLanguageChanged extends OnboardingState {
  final String language;

  const OnboardingLanguageChanged({required this.language});

  @override
  List<Object> get props => [language];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError({required this.message});

  @override
  List<Object> get props => [message];
}
