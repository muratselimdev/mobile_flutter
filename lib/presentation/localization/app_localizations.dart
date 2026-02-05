import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale, this._translations, this._fallbackTranslations);

  final Locale locale;
  final Map<String, dynamic> _translations;
  final Map<String, dynamic> _fallbackTranslations;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
    Locale('de'),
    Locale('es'),
    Locale('ru'),
    Locale('pl'),
    Locale('fr'),
    Locale('pt'),
    Locale('it'),
    Locale('ar'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'), const {}, const {});
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final languageCode = locale.languageCode;
    final translations = await _loadTranslations(languageCode);
    if (languageCode == 'en') {
      return AppLocalizations(locale, translations, translations);
    }
    final fallback = await _loadTranslations('en');
    return AppLocalizations(locale, translations, fallback);
  }

  bool get isRtl =>
      const {'ar', 'fa', 'he', 'ur'}.contains(locale.languageCode);

  String t(String key) {
    final value = _lookupValue(key);
    if (value == null) {
      return _humanizeKey(key);
    }
    return value.toString();
  }

  List<String> list(String key) {
    final value = _lookupValue(key);
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const <String>[];
  }

  List<Map<String, dynamic>> mapList(String key) {
    final value = _lookupValue(key);
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const <Map<String, dynamic>>[];
  }

  Object? _lookupValue(String key) {
    final primary = _lookupInMap(_translations, key);
    if (primary != null) {
      return primary;
    }
    return _lookupInMap(_fallbackTranslations, key);
  }

  Object? _lookupInMap(Map<String, dynamic> source, String key) {
    Object? current = source;
    for (final part in key.split('.')) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else {
        return null;
      }
    }
    return current;
  }

  static Future<Map<String, dynamic>> _loadTranslations(
    String languageCode,
  ) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/lang/$languageCode.json',
      );
      final decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Ignore and fall back to empty map.
    }
    return <String, dynamic>{};
  }

  static String _humanizeKey(String key) {
    final raw = key.split('.').last;
    if (raw.isEmpty) {
      return key;
    }
    final withSpaces = raw.replaceAll('_', ' ').replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) {
        return '${match.group(1)} ${match.group(2)}';
      },
    );
    return withSpaces
        .split(' ')
        .map((word) {
          if (word.isEmpty) {
            return word;
          }
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationX on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
