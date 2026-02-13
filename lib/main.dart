import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/bloc/app_language_cubit.dart';
import 'presentation/bloc/location_cubit.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'data/services/location_service.dart';
import 'data/services/auth_service.dart';
import 'presentation/localization/app_localizations.dart';
import 'presentation/pages/one_clinic_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppLanguageCubit()),
        BlocProvider(
          create: (_) =>
              LocationCubit(locationService: LocationService())
                ..getCurrentLocation(),
        ),
        BlocProvider(create: (_) => AuthBloc(authService: AuthService())),
      ],
      child: BlocBuilder<AppLanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateTitle: (context) => context.loc.t('app.name'),
            builder: (context, child) {
              final loc = context.loc;
              return Directionality(
                textDirection: loc.isRtl
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF16A34A),
              ),
              useMaterial3: true,
              fontFamily: GoogleFonts.manrope().fontFamily,
              textTheme: GoogleFonts.manropeTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: const OneClinicMainPage(),
          );
        },
      ),
    );
  }
}
