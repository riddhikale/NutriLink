import 'package:flutter/material.dart';
import 'en.dart';
import 'hi.dart';
import 'mr.dart';

class AppTranslations {
  static final Map<String, Map<String, String>> localizedValues = {
    'en': enStrings,
    'hi': hiStrings,
    'mr': mrStrings,
  };

  static String t(BuildContext context, String key) {
    final langCode = Localizations.localeOf(context).languageCode;
    return localizedValues[langCode]?[key]
        ?? localizedValues['en']?[key]
        ?? key;
  }
}