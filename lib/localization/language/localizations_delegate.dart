import 'package:flutter/material.dart';
import 'package:multilanguageandvoice/localization/language/language_ar.dart';
import 'package:multilanguageandvoice/localization/language/language_en.dart';
import 'package:multilanguageandvoice/localization/language/language_hi.dart';
import 'package:multilanguageandvoice/localization/language/language_tr.dart';
import 'package:multilanguageandvoice/localization/language/languages.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'hi','tr'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'hi':
        return LanguageHi();
      case 'tr':
        return LanguageTR();

      default:
        return LanguageEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}