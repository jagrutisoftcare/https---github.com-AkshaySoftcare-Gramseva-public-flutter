import 'package:flutter/material.dart';

class LanguageHelper {
  convertLangNameToLocale(String langNameToConvert) {
    Locale convertedLocale;
    switch (langNameToConvert) {
      case 'मराठी':
        convertedLocale = const Locale('mr', 'Mr');
        break;
      case 'English':
        convertedLocale = const Locale('en', 'EN');
        break;
      default:
        convertedLocale = const Locale('mr', 'Mr');
    }
    return convertedLocale;
  }

  convertLocaleToLangName(String localeToConvert) {
    String langName;
    switch (localeToConvert) {
      case 'mr':
        langName = "मराठी";
        break;
      case 'en':
        langName = "English";
        break;
      default:
        langName = "मराठी";
    }
    return langName;
  }
}
