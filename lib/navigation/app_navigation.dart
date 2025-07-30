import 'package:flutter/material.dart';
import 'package:swiftwallet/screens/login_screen.dart';
import 'package:swiftwallet/screens/home_screen.dart';
import 'package:swiftwallet/screens/expense_form_screen.dart';
import 'package:swiftwallet/screens/budget_screen.dart';
import 'package:swiftwallet/screens/reports_screen.dart';
import 'package:swiftwallet/screens/settings_screen.dart';
import 'package:swiftwallet/utils/modern_theme.dart';

class AppNavigation extends StatefulWidget {
  final bool isAuthenticated;
  final VoidCallback onLogin;
  final VoidCallback? onLogout;
  final bool darkMode;
  final String language;
  final String currency;
  final Function(bool) toggleDarkMode;
  final Function(String) updateLanguage;
  final Function(String) updateCurrency;

  const AppNavigation({
    Key? key,
    required this.isAuthenticated,
    required this.onLogin,
    this.onLogout,
    required this.darkMode,
    required this.language,
    required this.currency,
    required this.toggleDarkMode,
    required this.updateLanguage,
    required this.updateCurrency,
  }) : super(key: key);

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  
  final List<String> _routes = ['home', 'budget', 'reports', 'settings'];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToExpenseForm([Map<String, dynamic>? expense]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(expense: expense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAuthenticated) {
      return LoginScreen(onLogin: widget.onLogin);
    }

    final screens = [
      HomeScreen(
        darkMode: widget.darkMode,
        currency: widget.currency,
        onNavigateToExpenseForm: _navigateToExpenseForm,
      ),
      BudgetScreen(darkMode: widget.darkMode, currency: widget.currency),
      ReportsScreen(darkMode: widget.darkMode, currency: widget.currency),
      SettingsScreen(
        darkMode: widget.darkMode,
        language: widget.language,
        currency: widget.currency,
        toggleDarkMode: widget.toggleDarkMode,
        updateLanguage: widget.updateLanguage,
        updateCurrency: widget.updateCurrency,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: widget.darkMode 
          ? ModernAppTheme.darkSurface 
          : ModernAppTheme.lightSurface,
        elevation: ModernAppTheme.elevationSm,
        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
