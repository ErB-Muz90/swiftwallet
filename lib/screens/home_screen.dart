import 'package:flutter/material.dart';
import 'package:swiftwallet/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:swiftwallet/utils/currency_utils.dart';
import '../ui/custom_card.dart';

class HomeScreen extends StatefulWidget {
  final bool darkMode;
  final String currency;
  final Function([Map<String, dynamic>?])? onNavigateToExpenseForm;
  const HomeScreen({Key? key, required this.darkMode, this.currency = 'USD', this.onNavigateToExpenseForm}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> expenses = [];
  double totalSpent = 0;
  double monthlyBudget = 0;

  @override
  void initState() {
    super.initState();
    loadExpenses();
    loadBudget();
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final storedExpenses = prefs.getString('expenses');
    List<Map<String, dynamic>> expensesData = [];
    if (storedExpenses != null && storedExpenses.isNotEmpty) {
      expensesData = List<Map<String, dynamic>>.from(json.decode(storedExpenses));
    }
    setState(() {
      expenses = expensesData;
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;
      totalSpent = expensesData
        .where((expense) {
          final expenseDate = DateTime.tryParse(expense['date'] ?? '') ?? DateTime(1970);
          return expenseDate.month == currentMonth && expenseDate.year == currentYear;
        })
        .fold(0.0, (sum, expense) => sum + (expense['amount'] ?? 0));
    });
  }

  Future<void> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final budget = prefs.getString('monthlyBudget');
    setState(() {
      monthlyBudget = budget != null ? double.tryParse(budget) ?? 0 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final budgetPercentage = monthlyBudget > 0 ? (totalSpent / monthlyBudget) * 100 : 0;
    
    return Scaffold(
      backgroundColor: widget.darkMode ? const Color(0xFF1a202c) : const Color(0xFFf3f4f6),
      appBar: AppBar(
        title: Text(i18n.translate('monthlyOverview') ?? 'Monthly Overview'),
        backgroundColor: widget.darkMode ? const Color(0xFF2d3748) : Colors.white,
        foregroundColor: widget.darkMode ? Colors.white : Colors.black,
        elevation: 3,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final padding = isLargeScreen ? 30.0 : 20.0;
          final cardPadding = isLargeScreen ? 25.0 : 20.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Welcome Card
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i18n.translate('welcome') ?? 'Welcome'}, ${''}!',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: widget.darkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        i18n.translate('totalBalance') ?? 'Total Balance',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 16 : 14,
                          color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF6b7280),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${CurrencyUtils.formatAmount(0, widget.currency)}',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 32 : 28,
                          fontWeight: FontWeight.bold,
                          color: widget.darkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Quick Actions
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.translate('quickActions') ?? 'Quick Actions',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: widget.darkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (isLargeScreen)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickAction(
                              Icons.add,
                              i18n.translate('addExpense') ?? 'Add Expense',
                              () => widget.onNavigateToExpenseForm?.call(),
                              size: isLargeScreen ? 70 : 60,
                            ),
                            _buildQuickAction(
                              Icons.bar_chart,
                              i18n.translate('viewReports') ?? 'View Reports',
                              () {},
                              size: isLargeScreen ? 70 : 60,
                            ),
                            _buildQuickAction(
                              Icons.account_balance_wallet,
                              i18n.translate('manageBudget') ?? 'Budget',
                              () {},
                              size: isLargeScreen ? 70 : 60,
                            ),
                          ],
                        )
                      else
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildQuickAction(
                              Icons.add,
                              i18n.translate('addExpense') ?? 'Add Expense',
                              () => widget.onNavigateToExpenseForm?.call(),
                              size: 60,
                            ),
                            _buildQuickAction(
                              Icons.bar_chart,
                              i18n.translate('viewReports') ?? 'View Reports',
                              () {},
                              size: 60,
                            ),
                            _buildQuickAction(
                              Icons.account_balance_wallet,
                              i18n.translate('manageBudget') ?? 'Budget',
                              () {},
                              size: 60,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Recent Expenses
                CustomCard(
                  isDarkMode: widget.darkMode,
                  useGlassEffect: true,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            i18n.translate('recentExpenses') ?? 'Recent Expenses',
                            style: TextStyle(
                              fontSize: isLargeScreen ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: widget.darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              i18n.translate('viewAll') ?? 'View All',
                              style: TextStyle(
                                color: const Color(0xFF3b82f6),
                                fontWeight: FontWeight.w600,
                                fontSize: isLargeScreen ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Expense List
                      if (expenses.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: widget.darkMode ? const Color(0xFF2d3748) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: isLargeScreen ? 80 : 64,
                                color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF9ca3af),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                i18n.translate('noExpenses') ?? 'No expenses recorded yet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 18 : 16,
                                  color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF6b7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                i18n.translate('addFirstExpense') ?? 'Add Your First Expense',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 16 : 14,
                                  color: widget.darkMode ? const Color(0xFFa0aec0) : const Color(0xFF9ca3af),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...expenses.take(isLargeScreen ? 8 : 5).map((expense) => _buildExpenseItem(expense, i18n, isLargeScreen: isLargeScreen)),
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

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onPressed, {double size = 60}) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF3b82f6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: IconButton(
            icon: Icon(icon, color: const Color(0xFF3b82f6)),
            onPressed: onPressed,
            iconSize: size * 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseItem(Map<String, dynamic> expense, AppLocalizations i18n, {bool isLargeScreen = false}) {
    final date = DateTime.tryParse(expense['date'] ?? '') ?? DateTime.now();
    final iconSize = (isLargeScreen ? 48.0 : 40.0);
    final fontSize = isLargeScreen ? 18.0 : 16.0;
    final detailFontSize = isLargeScreen ? 14.0 : 12.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: isLargeScreen ? 15 : 10),
      padding: EdgeInsets.all(isLargeScreen ? 20 : 15),
      decoration: BoxDecoration(
        color: widget.darkMode ? const Color(0xFF2d3748) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFF3b82f6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(expense['category'] ?? 'Other'),
              color: const Color(0xFF3b82f6),
              size: iconSize * 0.6,
            ),
          ),
          SizedBox(width: isLargeScreen ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense['title'] ?? '',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: widget.darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '${expense['category']} • ${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: detailFontSize,
                    color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF6b7280),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${CurrencyUtils.formatAmount((expense['amount'] ?? 0).toDouble(), widget.currency)}',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.darkMode ? Colors.white : Colors.black,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => widget.onNavigateToExpenseForm?.call(expense),
                    icon: Icon(
                      Icons.edit,
                      size: isLargeScreen ? 20 : 16,
                      color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF6b7280),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteExpense(expense, i18n),
                    icon: Icon(
                      Icons.delete,
                      size: isLargeScreen ? 20 : 16,
                      color: const Color(0xFFef4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.home;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  Future<void> _deleteExpense(Map<String, dynamic> expense, AppLocalizations i18n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(i18n.translate('deleteExpense') ?? 'Delete Expense'),
        content: Text(i18n.translate('deleteConfirm') ?? 'Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(i18n.translate('cancel') ?? 'Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFef4444)),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(i18n.translate('delete') ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final storedExpenses = prefs.getString('expenses');
        List<Map<String, dynamic>> expensesList = [];
        if (storedExpenses != null && storedExpenses.isNotEmpty) {
          expensesList = List<Map<String, dynamic>>.from(json.decode(storedExpenses));
        }
        expensesList.removeWhere((item) => item['id'] == expense['id']);
        await prefs.setString('expenses', json.encode(expensesList));
        loadExpenses(); // Reload expenses
      } catch (error) {
        print('Error deleting expense: $error');
      }
    }
  }
}
