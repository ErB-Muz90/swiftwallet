import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:swiftwallet/utils/localization.dart';
import 'package:swiftwallet/utils/currency_utils.dart';
import 'package:swiftwallet/utils/modern_theme.dart';
import '../ui/custom_card.dart';
import '../ui/custom_button.dart';
import '../ui/custom_input.dart';

class BudgetScreen extends StatefulWidget {
  final bool darkMode;
  final String currency;
  const BudgetScreen({Key? key, required this.darkMode, this.currency = 'USD'}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _budgetController = TextEditingController();
  double _currentSpending = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadBudget();
    _calculateCurrentSpending();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadBudget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budget = prefs.getString('monthlyBudget');
      if (budget != null) {
        setState(() {
          _budgetController.text = budget;
        });
      }
    } catch (error) {
      print('Error loading budget: $error');
    }
  }

  Future<void> _calculateCurrentSpending() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedExpenses = prefs.getString('expenses');
      final expenses = storedExpenses != null ? List<Map<String, dynamic>>.from(json.decode(storedExpenses)) : <Map<String, dynamic>>[];
      
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;
      
      final monthlyTotal = expenses
          .where((expense) {
            final expenseDate = DateTime.tryParse(expense['date'] ?? '') ?? DateTime(1970);
            return expenseDate.month == currentMonth && expenseDate.year == currentYear;
          })
          .fold(0.0, (sum, expense) => sum + (expense['amount'] ?? 0));
      
      setState(() {
        _currentSpending = monthlyTotal;
      });
    } catch (error) {
      print('Error calculating spending: $error');
    }
  }

  void _saveBudget() async {
    final budgetText = _budgetController.text.trim();
    if (budgetText.isEmpty || double.tryParse(budgetText) == null) {
      final i18n = AppLocalizations.of(context)!;
      _showAlert(i18n.translate('error') ?? 'Error', i18n.translate('enterValidBudget') ?? 'Please enter a valid budget amount');
      return;
    }

    setState(() { _saving = true; });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('monthlyBudget', budgetText);
      final i18n = AppLocalizations.of(context)!;
      _showAlert(i18n.translate('success') ?? 'Success', i18n.translate('budgetSaved') ?? 'Budget saved successfully');
      _calculateCurrentSpending();
    } catch (error) {
      print('Error saving budget: $error');
      final i18n = AppLocalizations.of(context)!;
      _showAlert(i18n.translate('error') ?? 'Error', i18n.translate('saveError') ?? 'Failed to save budget. Please try again.');
    } finally {
      setState(() { _saving = false; });
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final monthlyBudget = double.tryParse(_budgetController.text) ?? 0;
    final remaining = monthlyBudget - _currentSpending;
    final percentage = monthlyBudget > 0 ? (_currentSpending / monthlyBudget) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.translate('budget') ?? 'Budget'),
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
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Set Budget Card
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.translate('setMonthlyBudget') ?? 'Set Monthly Budget',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: titleFontSize,
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOnSurface 
                            : ModernAppTheme.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: ModernAppTheme.spacingMd),
                      CustomInput(
                        label: '',
                        hint: i18n.translate('enterBudgetAmount') ?? 'Enter budget amount',
                        controller: _budgetController,
                        isDarkMode: widget.darkMode,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: ModernAppTheme.spacingMd),
                      CustomButton(
                        onPressed: _saving ? () {} : _saveBudget,
                        text: i18n.translate('saveBudget') ?? 'Save Budget',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        width: double.infinity,
                        isDarkMode: widget.darkMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ModernAppTheme.spacingLg),
                // Budget Overview Card
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.translate('budgetOverview') ?? 'Budget Overview',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: titleFontSize,
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOnSurface 
                            : ModernAppTheme.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: ModernAppTheme.spacingMd),
                      // Progress Bar
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: widget.darkMode 
                            ? ModernAppTheme.darkSurface 
                            : ModernAppTheme.lightSurface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (percentage / 100).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: percentage > 100 
                                ? ModernAppTheme.errorColor 
                                : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: ModernAppTheme.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${i18n.translate('spent') ?? 'Spent'}: ${CurrencyUtils.formatAmount(_currentSpending, widget.currency)}',
                            style: TextStyle(
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                            ),
                          ),
                          Text(
                            '${i18n.translate('remaining') ?? 'Remaining'}: ${CurrencyUtils.formatAmount(remaining, widget.currency)}',
                            style: TextStyle(
                              color: widget.darkMode 
                                ? ModernAppTheme.darkOnSurface 
                                : ModernAppTheme.lightOnSurface,
                              fontWeight: remaining < 0 ? FontWeight.bold : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: ModernAppTheme.spacingSm),
                      Text(
                        '${i18n.translate('budget') ?? 'Budget'}: ${CurrencyUtils.formatAmount(monthlyBudget, widget.currency)}',
                        style: TextStyle(
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOnSurface 
                            : ModernAppTheme.lightOnSurface,
                        ),
                      ),
                      if (percentage > 100)
                        Padding(
                          padding: const EdgeInsets.only(top: ModernAppTheme.spacingSm),
                          child: Text(
                            i18n.translate('budgetExceeded') ?? 'Budget exceeded!',
                            style: const TextStyle(
                              color: ModernAppTheme.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: ModernAppTheme.spacingLg),
                // Budget Tips Card
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.translate('budgetTips') ?? 'Budgeting Tips',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: titleFontSize,
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOnSurface 
                            : ModernAppTheme.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: ModernAppTheme.spacingSm),
                      Text(
                        '• ${i18n.translate('tip1') ?? 'Track all your expenses to understand your spending habits'}',
                        style: TextStyle(
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOutline 
                            : ModernAppTheme.lightOutline,
                        ),
                      ),
                      Text(
                        '• ${i18n.translate('tip2') ?? 'Set realistic budget limits for each category'}',
                        style: TextStyle(
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOutline 
                            : ModernAppTheme.lightOutline,
                        ),
                      ),
                      Text(
                        '• ${i18n.translate('tip3') ?? 'Review your budget monthly to adjust for changes'}',
                        style: TextStyle(
                          color: widget.darkMode 
                            ? ModernAppTheme.darkOutline 
                            : ModernAppTheme.lightOutline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTip(String tip, bool darkMode, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ModernAppTheme.spacingXs),
      child: Text(
        '• $tip',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: darkMode 
            ? ModernAppTheme.darkOutline 
            : ModernAppTheme.lightOutline,
        ),
      ),
    );
  }
}
