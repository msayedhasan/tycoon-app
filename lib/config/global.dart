import 'package:flutter/material.dart';

import '../models/user.dart';

class Globals {
  // Variables used in app
  static bool debug = true;
  // static String host = 'http://172.20.10.3:3000';
  static String host = 'http://192.168.1.18:3000';

  // static String host = 'https://www.tycoonx.link';
  static String binanceHost = 'https://api.binance.com';

  static User? user;

  static String selectedCurrency = '';
  static String selectedLanguage = '';
  static String oldLang = '';

  static Color primaryColor = const Color(0xff0c425d);

  static Widget tableHeader(title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Shared Preference Variables //
  static String prefLanguage = 'language';
  static String prefTheme = 'theme';
  static String prefFont = 'font';
  static String prefDarkOption = 'darkOption';

  // singlton
  static final Globals _instance = Globals.internal();

  factory Globals() => _instance;

  Globals.internal();
}
