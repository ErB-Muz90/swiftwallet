import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService with ChangeNotifier {
  static late SharedPreferences _prefs;
  static String _language = 'en';
  static bool _darkMode = false;
  static String _currency = 'USD';
  static final SettingsService _instance = SettingsService._internal();

  SettingsService._internal();

  static SettingsService get instance => _instance;

  static String get language => _language;
  static bool get darkMode => _darkMode;
  static String get currency => _currency;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _language = _prefs.getString('language') ?? 'en';
    _darkMode = _prefs.getBool('darkMode') ?? false;
    _currency = _prefs.getString('currency') ?? 'USD';
  }

  static Future<void> setLanguage(String newLanguage) async {
    _language = newLanguage;
    await _prefs.setString('language', newLanguage);
    _instance.notifyListeners();
  }

  static Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _prefs.setBool('darkMode', value);
    _instance.notifyListeners();
  }

  static Future<void> setCurrency(String newCurrency) async {
    _currency = newCurrency;
    await _prefs.setString('currency', newCurrency);
    _instance.notifyListeners();
  }
}
