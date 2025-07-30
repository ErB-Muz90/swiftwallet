import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/localization.dart';
import '../models/user.dart';
import '../services/export_service.dart';
import '../utils/currency_utils.dart';
import '../utils/modern_theme.dart';
import '../ui/custom_card.dart';
import 'package:swiftwallet/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final String language;
  final String currency;
  final Function(bool) toggleDarkMode;
  final Function(String) updateLanguage;
  final Function(String) updateCurrency;
  final VoidCallback? onLogout;
  const SettingsScreen({
    Key? key,
    required this.darkMode,
    required this.language,
    required this.currency,
    required this.toggleDarkMode,
    required this.updateLanguage,
    required this.updateCurrency,
    this.onLogout,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'sw', 'name': 'Swahili'},
  ];

  final List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'US Dollar (USD)', 'symbol': r'$',},
    {'code': 'EUR', 'name': 'Euro (EUR)', 'symbol': '€',},
    {'code': 'GBP', 'name': 'British Pound (GBP)', 'symbol': '£',},
    {'code': 'KES', 'name': 'Kenyan Shilling (KES)', 'symbol': 'KSh',},
    {'code': 'TZS', 'name': 'Tanzanian Shilling (TZS)', 'symbol': 'TSh',},
  ];

  void _handleLogout() {
    final i18n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(i18n.translate('logout') ?? 'Logout'),
        content: Text(i18n.translate('logoutConfirm') ?? 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(i18n.translate('cancel') ?? 'Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFef4444)),
            onPressed: () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  Navigator.of(context).pop(); // Close dialog
                  widget.onLogout?.call();
                }
              } catch (error) {
                print('Error during logout: $error');
              }
            },
            child: Text(i18n.translate('logout') ?? 'Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: widget.darkMode 
        ? ModernAppTheme.darkBackground 
        : ModernAppTheme.lightBackground,
      appBar: AppBar(
        title: Text(i18n.translate('settings') ?? 'Settings'),
        backgroundColor: widget.darkMode ? ModernAppTheme.darkSurface : ModernAppTheme.lightSurface,
        foregroundColor: widget.darkMode ? ModernAppTheme.darkOnSurface : ModernAppTheme.lightOnSurface,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final padding = isLargeScreen ? ModernAppTheme.spacingXl : ModernAppTheme.spacingLg;
          final cardPadding = isLargeScreen ? ModernAppTheme.spacingLg : ModernAppTheme.spacingMd;
          final titleFontSize = isLargeScreen 
            ? Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24.0
            : Theme.of(context).textTheme.headlineSmall?.fontSize ?? 20.0;
          final bodyFontSize = isLargeScreen 
            ? Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16.0
            : Theme.of(context).textTheme.bodyLarge?.fontSize ?? 14.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Appearance Section
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_6,
                            color: widget.darkMode 
                              ? ModernAppTheme.primaryColor 
                              : ModernAppTheme.primaryColor,
                            size: isLargeScreen ? 28 : 24,
                          ),
                          SizedBox(width: isLargeScreen ? ModernAppTheme.spacingMd : ModernAppTheme.spacingSm),
                          Text(
                            i18n.translate('appearance') ?? 'Appearance',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: titleFontSize,
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? ModernAppTheme.spacingLg : ModernAppTheme.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            i18n.translate('darkMode') ?? 'Dark Mode',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: bodyFontSize,
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                            ),
                          ),
                          Switch(
                            value: widget.darkMode,
                            onChanged: widget.toggleDarkMode,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? ModernAppTheme.spacingXl : ModernAppTheme.spacingLg),
                // Language Section
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: widget.darkMode 
                              ? ModernAppTheme.primaryColor 
                              : ModernAppTheme.primaryColor,
                            size: isLargeScreen ? 28 : 24,
                          ),
                          SizedBox(width: isLargeScreen ? ModernAppTheme.spacingMd : ModernAppTheme.spacingSm),
                          Text(
                            i18n.translate('language') ?? 'Language',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: titleFontSize,
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? ModernAppTheme.spacingLg : ModernAppTheme.spacingMd),
                      ...languages.map((lang) => InkWell(
                        onTap: () => widget.updateLanguage(lang['code']!),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: ModernAppTheme.spacingSm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang['name']!,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: bodyFontSize,
                                  color: widget.darkMode 
                                    ? ModernAppTheme.darkOnSurface 
                                    : ModernAppTheme.lightOnSurface,
                                ),
                              ),
                              if (widget.language == lang['code'])
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? ModernAppTheme.spacingXl : ModernAppTheme.spacingLg),
                // Currency Section
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.currency_exchange,
                            color: widget.darkMode 
                              ? ModernAppTheme.primaryColor 
                              : ModernAppTheme.primaryColor,
                            size: isLargeScreen ? 28 : 24,
                          ),
                          SizedBox(width: isLargeScreen ? ModernAppTheme.spacingMd : ModernAppTheme.spacingSm),
                          Text(
                            i18n.translate('currency') ?? 'Currency',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: titleFontSize,
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? ModernAppTheme.spacingLg : ModernAppTheme.spacingMd),
                      ...currencies.map((currency) => InkWell(
                        onTap: () => widget.updateCurrency(currency['code']!),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: ModernAppTheme.spacingSm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${currency['name']!} (${currency['code']})',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: bodyFontSize,
                                  color: widget.darkMode 
                                    ? ModernAppTheme.darkOnSurface 
                                    : ModernAppTheme.lightOnSurface,
                                ),
                              ),
                              Text(
                                CurrencyUtils.getCurrencySymbol(currency['code']!),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: widget.darkMode 
                                    ? ModernAppTheme.primaryColor 
                                    : ModernAppTheme.primaryColor,
                                ),
                              ),
                              if (widget.currency == currency['code'])
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? ModernAppTheme.spacingXl : ModernAppTheme.spacingLg),
                // Account Section
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: widget.darkMode 
                              ? ModernAppTheme.primaryColor 
                              : ModernAppTheme.primaryColor,
                            size: isLargeScreen ? 28 : 24,
                          ),
                          SizedBox(width: isLargeScreen ? ModernAppTheme.spacingMd : ModernAppTheme.spacingSm),
                          Text(
                            i18n.translate('account') ?? 'Account',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: titleFontSize,
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? ModernAppTheme.spacingLg : ModernAppTheme.spacingMd),
                      InkWell(
                        onTap: _handleLogout,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: ModernAppTheme.spacingSm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                i18n.translate('logout') ?? 'Logout',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: bodyFontSize,
                                  color: ModernAppTheme.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.logout,
                                color: ModernAppTheme.errorColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? ModernAppTheme.spacingXl : ModernAppTheme.spacingLg),
                // Version Info
                Center(
                  child: Text(
                    'SwiftWallet v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.darkMode 
                        ? ModernAppTheme.darkOutline 
                        : ModernAppTheme.lightOutline,
                    ),
                  ),
                ),
                SizedBox(height: isLargeScreen ? ModernAppTheme.spacingXl : ModernAppTheme.spacingMd),
              ],
            ),
          );
        },
      ),
    );
  }
}
