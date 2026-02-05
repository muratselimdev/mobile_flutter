import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/app_localizations.dart';

class AppLanguageCubit extends Cubit<Locale> {
  AppLanguageCubit() : super(const Locale('en'));

  void setLocale(Locale locale) {
    emit(_normalizeLocale(locale));
  }

  void setLocaleByCode(String code) {
    final normalized = code.trim().toLowerCase();
    final supported = AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == normalized,
      orElse: () => const Locale('en'),
    );
    emit(supported);
  }

  Locale _normalizeLocale(Locale locale) {
    final supported = AppLocalizations.supportedLocales.firstWhere(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      orElse: () => const Locale('en'),
    );
    return supported;
  }
}
