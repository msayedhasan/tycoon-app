import 'package:flutter/material.dart';
import './asset.dart';
import '../../app_locale_delegate.dart';

class Translate {
  final Locale locale;

  Translate(this.locale);

  static Translate of(BuildContext context) {
    return Localizations.of(context, Translate);
  }

  static const LocalizationsDelegate<Translate> delegate = AppLocaleDelegate();

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    final jsonMap = await UtilAsset.loadJson(
      "assets/locale/${locale.languageCode}.json",
    );

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? 'Unknown';
  }
}
