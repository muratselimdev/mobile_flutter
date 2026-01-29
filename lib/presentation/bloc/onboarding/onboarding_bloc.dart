import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<InitializeOnboardingEvent>(_onInitialize);
    on<NavigateToSignInEvent>(_onNavigateToSignIn);
    on<NavigateToCreateAccountEvent>(_onNavigateToCreateAccount);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onInitialize(
    InitializeOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    try {
      // Simulate loading
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const OnboardingLoaded(currentLanguage: 'TR'));
    } catch (e) {
      emit(OnboardingError(message: e.toString()));
    }
  }

  Future<void> _onNavigateToSignIn(
    NavigateToSignInEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const NavigateToSignInState());
  }

  Future<void> _onNavigateToCreateAccount(
    NavigateToCreateAccountEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const NavigateToCreateAccountState());
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(OnboardingLanguageChanged(language: event.language));
    } catch (e) {
      emit(OnboardingError(message: e.toString()));
    }
  }
}
