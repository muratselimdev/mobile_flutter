part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class InitializeOnboardingEvent extends OnboardingEvent {
  const InitializeOnboardingEvent();
}

class NavigateToSignInEvent extends OnboardingEvent {
  const NavigateToSignInEvent();
}

class NavigateToCreateAccountEvent extends OnboardingEvent {
  const NavigateToCreateAccountEvent();
}

class ChangeLanguageEvent extends OnboardingEvent {
  final String language;

  const ChangeLanguageEvent({required this.language});

  @override
  List<Object> get props => [language];
}
