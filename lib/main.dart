import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftwallet/navigation/app_navigation.dart';
import 'package:swiftwallet/utils/localization.dart';
import 'package:swiftwallet/utils/theme.dart';
import 'package:swiftwallet/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.init();
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const SwiftWalletApp());
}

class SwiftWalletApp extends StatefulWidget {
  const SwiftWalletApp({super.key});

  @override
  State<SwiftWalletApp> createState() => _SwiftWalletAppState();
}

class _SwiftWalletAppState extends State<SwiftWalletApp> {
  bool isAuthenticated = false;
  String language = SettingsService.language;
  bool darkMode = SettingsService.darkMode;
  String currency = SettingsService.currency;

  @override
  void initState() {
    super.initState();
    SettingsService.instance.addListener(_settingsListener);
  }

  @override
  void dispose() {
    SettingsService.instance.removeListener(_settingsListener);
    super.dispose();
  }

  void _settingsListener() {
    setState(() {
      language = SettingsService.language;
      darkMode = SettingsService.darkMode;
      currency = SettingsService.currency;
    });
  }

  void onLogin() {
    setState(() {
      isAuthenticated = true;
    });
  }

  void onLogout() {
    setState(() {
      isAuthenticated = false;
    });
  }

  void toggleDarkMode(bool value) {
    SettingsService.setDarkMode(value);
  }

  void updateLanguage(String languageCode) {
    SettingsService.setLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftWallet',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(language),
      supportedLocales: const [Locale('en'), Locale('sw')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AppNavigation(
        isAuthenticated: isAuthenticated,
        onLogin: onLogin,
        onLogout: onLogout,
        darkMode: darkMode,
        language: language,
        currency: currency,
        toggleDarkMode: (value) => SettingsService.setDarkMode(value),
        updateLanguage: (newLanguage) => SettingsService.setLanguage(newLanguage),
        updateCurrency: (newCurrency) => SettingsService.setCurrency(newCurrency),
      ),
    );
  }
}
