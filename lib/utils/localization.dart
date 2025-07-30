import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome to SwiftWallet',
      'loginSubtitle': 'Track your expenses with ease',
      'email': 'Email Address',
      'enterEmail': 'Please enter your email address',
      'sendOtp': 'Send OTP',
      'sending': 'Sending...',
      'enterOtp': 'Enter OTP Code',
      'verifyOtp': 'Verify OTP',
      'otpSent': 'OTP code sent to your email',
      'otpError': 'Failed to send OTP. Please try again.',
      'invalidOtp': 'Invalid OTP code',
      'home': 'Home',
      'monthlyOverview': 'Monthly Overview',
      'budget': 'Budget',
      'spent': 'Spent',
      'ofBudgetUsed': 'of budget used',
      'addExpense': 'Add Expense',
      'reports': 'Reports',
      'settings': 'Settings',
      'recentExpenses': 'Recent Expenses',
      'noExpenses': 'No expenses recorded yet',
      'addFirstExpense': 'Add Your First Expense',
      'deleteExpense': 'Delete Expense',
      'deleteConfirm': 'Are you sure you want to delete this expense?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'expenseTitle': 'Expense Title',
      'enterTitle': 'Enter expense title',
      'amount': 'Amount',
      'enterAmount': 'Enter amount',
      'category': 'Category',
      'date': 'Date',
      'food': 'Food',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'entertainment': 'Entertainment',
      'utilities': 'Utilities',
      'healthcare': 'Healthcare',
      'education': 'Education',
      'other': 'Other',
      'saveExpense': 'Save Expense',
      'updateExpense': 'Update Expense',
      'fillAllFields': 'Please fill in all fields correctly',
      'saveError': 'Failed to save expense. Please try again.',
      'setMonthlyBudget': 'Set Monthly Budget',
      'enterBudget': 'Enter your monthly budget',
      'saveBudget': 'Save Budget',
      'budgetOverview': 'Budget Overview',
      'monthlyBudget': 'Monthly Budget',
      'spentThisMonth': 'Spent This Month',
      'remaining': 'Remaining',
      'budgetTips': 'Budgeting Tips',
      'tip1': 'Track all your expenses to understand your spending habits',
      'tip2': 'Set realistic budget limits for each category',
      'tip3': 'Review your budget monthly to adjust for changes',
      'enterValidBudget': 'Please enter a valid budget amount',
      'budgetSaved': 'Budget saved successfully',
      'expenseReports': 'Expense Reports',
      'spendingByCategory': 'Spending by Category',
      'spendingDistribution': 'Spending Distribution',
      'noDataAvailable': 'No data available',
      'exportReports': 'Export Reports',
      'sharingNotAvailable': 'Sharing is not available on this device',
      'exportError': 'Failed to export report. Please try again.',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'account': 'Account',
      'logout': 'Logout',
      'logoutConfirm': 'Are you sure you want to logout?',
      'error': 'Error',
      'success': 'Success',
      'login': 'Login',
    },
    'sw': {
      'welcome': 'Karibu kwa SwiftWallet',
      'loginSubtitle': 'Fuatilia matumizi yako kwa urahisi',
      'email': 'Barua Pepe',
      'enterEmail': 'Tafadhali ingiza barua pepe yako',
      'sendOtp': 'Tuma OTP',
      'sending': 'Inatuma...',
      'enterOtp': 'Ingiza Msimbo wa OTP',
      'verifyOtp': 'Thibitisha OTP',
      'otpSent': 'Msimbo wa OTP umetumwa kwa barua pepe yako',
      'otpError': 'Imeshindwa kutuma OTP. Tafadhali jaribu tena.',
      'invalidOtp': 'Msimbo wa OTP si sahihi',
      'home': 'Nyumbani',
      'monthlyOverview': 'Mapitio ya Mwezi',
      'budget': 'Bajeti',
      'spent': 'Ime tumika',
      'ofBudgetUsed': 'ya bajeti iliyotumika',
      'addExpense': 'Ongeza Matumizi',
      'reports': 'Ripoti',
      'settings': 'Mipangilio',
      'recentExpenses': 'Matumizi ya Hivi Karibuni',
      'noExpenses': 'Hakuna matumizi yaliyorekodiwa bado',
      'addFirstExpense': 'Ongeza Matumizi Yako ya Kwanza',
      'deleteExpense': 'Futa Matumizi',
      'deleteConfirm': 'Je, una uhakika unataka kufuta matumizi haya?',
      'cancel': 'Ghairi',
      'delete': 'Futa',
      'expenseTitle': 'Kichwa cha Matumizi',
      'enterTitle': 'Ingiza kichwa cha matumizi',
      'amount': 'Kiasi',
      'enterAmount': 'Ingiza kiasi',
      'category': 'Jamii',
      'date': 'Tarehe',
      'food': 'Chakula',
      'transport': 'Usafiri',
      'shopping': 'Ununuzi',
      'entertainment': 'Burudani',
      'utilities': 'Huduma',
      'healthcare': 'Afya',
      'education': 'Elimu',
      'other': 'Nyingine',
      'saveExpense': 'Hifadhi Matumizi',
      'updateExpense': 'Sasisha Matumizi',
      'fillAllFields': 'Tafadhali jaza sehemu zote kwa usahihi',
      'saveError': 'Imeshindwa kuhifadhi matumizi. Tafadhali jaribu tena.',
      'setMonthlyBudget': 'Weka Bajeti ya Mwezi',
      'enterBudget': 'Ingiza bajeti yako ya mwezi',
      'saveBudget': 'Hifadhi Bajeti',
      'budgetOverview': 'Mapitio ya Bajeti',
      'monthlyBudget': 'Bajeti ya Mwezi',
      'spentThisMonth': 'Ime tumika Mwezi Huu',
      'remaining': 'Inayobaki',
      'budgetTips': 'Vidokezo vya Bajeti',
      'tip1': 'Fuatilia matumizi yako yote ili kuelewa tabia zako za matumizi',
      'tip2': 'Weka mipaka ya bajeti inayofaa kwa kila jamii',
      'tip3': 'Pitia bajeti yako kila mwezi ili kurekebisha mabadiliko',
      'enterValidBudget': 'Tafadhali ingiza kiasi sahihi cha bajeti',
      'budgetSaved': 'Bajeti imehifadhiwa kwa mafanikio',
      'expenseReports': 'Ripoti za Matumizi',
      'spendingByCategory': 'Matumizi kwa Jamii',
      'spendingDistribution': 'Usambazaji wa Matumizi',
      'noDataAvailable': 'Hakuna data inayopatikana',
      'exportReports': 'Hamisha Ripoti',
      'sharingNotAvailable': 'Kushiriki hakupatikana kwenye kifaa hiki',
      'exportError': 'Imeshindwa kuhamisha ripoti. Tafadhali jaribu tena.',
      'appearance': 'Mwonekano',
      'darkMode': 'Hali ya Giza',
      'language': 'Lugha',
      'account': 'Akaunti',
      'logout': 'Toka',
      'logoutConfirm': 'Je, una uhakika unataka kutoka?',
      'error': 'Hitilafu',
      'success': 'Mafanikio',
      'login': 'Ingia',
    },
  };

  String? translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'sw'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
