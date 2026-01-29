import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/bloc/onboarding/onboarding_bloc.dart';
import 'presentation/pages/one_clinic_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Clinic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16A34A)),
        useMaterial3: true,
        fontFamily: GoogleFonts.manrope().fontFamily,
        textTheme: GoogleFonts.manropeTextTheme(Theme.of(context).textTheme),
      ),
      home: BlocProvider(
        create: (context) =>
            OnboardingBloc()..add(const InitializeOnboardingEvent()),
        child: const OneClinicMainPage(),
      ),
    );
  }
}
