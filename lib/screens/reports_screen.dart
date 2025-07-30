import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:swiftwallet/utils/localization.dart';
import 'package:swiftwallet/services/export_service.dart';
import 'package:swiftwallet/utils/currency_utils.dart';
import 'package:swiftwallet/models/expense.dart';
import 'package:swiftwallet/models/budget.dart';
import '../ui/custom_card.dart';

class ReportsScreen extends StatefulWidget {
  final bool darkMode;
  final String currency;
  const ReportsScreen({Key? key, required this.darkMode, this.currency = 'USD'}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> expenses = [];
  Map<String, double> categoryTotals = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedExpenses = prefs.getString('expenses');
      final expensesData = storedExpenses != null ? List<Map<String, dynamic>>.from(json.decode(storedExpenses)) : <Map<String, dynamic>>[];
      setState(() {
        expenses = expensesData;
        _processChartData(expensesData);
        loading = false;
      });
    } catch (error) {
      print('Error loading expenses: $error');
      setState(() { loading = false; });
    }
  }

  void _processChartData(List<Map<String, dynamic>> expensesData) {
    final Map<String, double> totals = {};
    for (final expense in expensesData) {
      final category = expense['category'] ?? 'Other';
      final amount = (expense['amount'] ?? 0).toDouble();
      totals[category] = (totals[category] ?? 0) + amount;
    }
    categoryTotals = totals;
  }

  Future<void> _exportToCSV() async {
    try {
      // Convert expenses to Expense models
      final expenseModels = expenses.map((e) => Expense(
        id: e['id'] ?? DateTime.now().toString(),
        title: e['title'] ?? '',
        amount: (e['amount'] ?? 0).toDouble(),
        category: e['category'] ?? 'Other',
        date: DateTime.tryParse(e['date'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      )).toList();
      
      // For now, we'll create empty budgets list
      final budgetModels = <Budget>[];
      
      final success = await ExportService.exportExpensesToCsv(
        expenseModels,
        budgetModels,
        widget.currency,
      );
      
      if (!success) {
        final i18n = AppLocalizations.of(context)!;
        _showAlert(i18n.translate('error') ?? 'Error', i18n.translate('exportError') ?? 'Failed to export report. Please try again.');
      }
    } catch (error) {
      print('Error exporting CSV: $error');
      final i18n = AppLocalizations.of(context)!;
      _showAlert(i18n.translate('error') ?? 'Error', i18n.translate('exportError') ?? 'Failed to export report. Please try again.');
    }
  }
  
  Future<void> _exportToPDF() async {
    try {
      // Convert expenses to Expense models
      final expenseModels = expenses.map((e) => Expense(
        id: e['id'] ?? DateTime.now().toString(),
        title: e['title'] ?? '',
        amount: (e['amount'] ?? 0).toDouble(),
        category: e['category'] ?? 'Other',
        date: DateTime.tryParse(e['date'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      )).toList();
      
      // For now, we'll create empty budgets list
      final budgetModels = <Budget>[];
      
      final success = await ExportService.exportExpensesToPdf(
        expenseModels,
        budgetModels,
        widget.currency,
      );
      
      if (!success) {
        final i18n = AppLocalizations.of(context)!;
        _showAlert(i18n.translate('error') ?? 'Error', i18n.translate('exportError') ?? 'Failed to export report. Please try again.');
      }
    } catch (error) {
      print('Error exporting PDF: $error');
      final i18n = AppLocalizations.of(context)!;
      _showAlert(i18n.translate('error') ?? 'Error', i18n.translate('exportError') ?? 'Failed to export report. Please try again.');
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
    
    if (loading) {
      return Scaffold(
        backgroundColor: widget.darkMode ? const Color(0xFF1a202c) : const Color(0xFFf3f4f6),
        appBar: AppBar(
          title: Text(i18n.translate('expenseReports') ?? 'Expense Reports'),
          backgroundColor: widget.darkMode ? const Color(0xFF2d3748) : Colors.white,
          foregroundColor: widget.darkMode ? Colors.white : Colors.black,
          elevation: 3,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: widget.darkMode ? const Color(0xFF1a202c) : const Color(0xFFf3f4f6),
      appBar: AppBar(
        title: Text(i18n.translate('expenseReports') ?? 'Expense Reports'),
        backgroundColor: widget.darkMode ? const Color(0xFF2d3748) : Colors.white,
        foregroundColor: widget.darkMode ? Colors.white : Colors.black,
        elevation: 3,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final padding = isLargeScreen ? 30.0 : 20.0;
          final cardPadding = isLargeScreen ? 25.0 : 20.0;
          final titleFontSize = isLargeScreen ? 20.0 : 18.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Spending by Category Chart
                CustomCard(
                  isDarkMode: widget.darkMode,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.translate('spendingByCategory') ?? 'Spending by Category',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: widget.darkMode ? Colors.white : const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (categoryTotals.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            i18n.translate('noDataAvailable') ?? 'No data available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF9ca3af),
                            ),
                          ),
                        )
                      else
                        _buildCategoryChart(isLargeScreen: isLargeScreen),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Category Breakdown
                if (categoryTotals.isNotEmpty)
                  CustomCard(
                    isDarkMode: widget.darkMode,
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i18n.translate('spendingDistribution') ?? 'Spending Distribution',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: widget.darkMode ? Colors.white : const Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ...categoryTotals.entries.map((entry) => _buildCategoryRow(entry.key, entry.value)),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                // Export Section
                CustomCard(
                  isDarkMode: widget.darkMode,
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.translate('exportReports') ?? 'Export Reports',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: widget.darkMode ? Colors.white : const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (isLargeScreen)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3b82f6),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: expenses.isEmpty ? null : _exportToCSV,
                                child: const Text(
                                  'CSV',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10b981),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: expenses.isEmpty ? null : _exportToPDF,
                                child: const Text(
                                  'PDF',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3b82f6),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: expenses.isEmpty ? null : _exportToCSV,
                                child: const Text(
                                  'CSV',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10b981),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: expenses.isEmpty ? null : _exportToPDF,
                                child: const Text(
                                  'PDF',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildCategoryChart({bool isLargeScreen = false}) {
    final maxAmount = categoryTotals.values.isNotEmpty ? categoryTotals.values.reduce((a, b) => a > b ? a : b) : 0.0;
    final colors = [0xFF3b82f6, 0xFF10b981, 0xFFf59e0b, 0xFFef4444, 0xFF8b5cf6, 0xFFf97316, 0xFF06b6d4, 0xFF84cc16];
    final textFontSize = isLargeScreen ? 16.0 : 14.0;
    final spacing = isLargeScreen ? 12.0 : 10.0;
    
    return Column(
      children: categoryTotals.entries.map((entry) {
        final index = categoryTotals.keys.toList().indexOf(entry.key);
        final percentage = maxAmount > 0 ? (entry.value / maxAmount) : 0.0;
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: widget.darkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: textFontSize,
                    ),
                  ),
                  Text(
                    '${CurrencyUtils.formatAmount(entry.value, widget.currency)}',
                    style: TextStyle(
                      color: widget.darkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textFontSize,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                height: isLargeScreen ? 10 : 8,
                decoration: BoxDecoration(
                  color: widget.darkMode ? const Color(0xFF4a5568) : const Color(0xFFe5e7eb),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(colors[index % colors.length]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryRow(String category, double amount) {
    final totalAmount = categoryTotals.values.fold(0.0, (sum, value) => sum + value);
    final percentage = totalAmount > 0 ? (amount / totalAmount) * 100 : 0.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 16,
              color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF6b7280),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${CurrencyUtils.formatAmount(amount, widget.currency)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.darkMode ? Colors.white : const Color(0xFF374151),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.darkMode ? const Color(0xFFcbd5e0) : const Color(0xFF9ca3af),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
