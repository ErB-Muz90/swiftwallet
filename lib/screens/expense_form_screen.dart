import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:swiftwallet/utils/localization.dart';
import '../ui/custom_input.dart';
import '../ui/custom_button.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Map<String, dynamic>? expense;
  const ExpenseFormScreen({Key? key, this.expense}) : super(key: key);

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  String _category = 'Food';
  DateTime _date = DateTime.now();
  bool _isEditing = false;
  late List<String> _categories;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categories = [
      'Food', 'Transport', 'Shopping', 'Entertainment',
      'Utilities', 'Healthcare', 'Education', 'Other'
    ];
    _isEditing = widget.expense != null;
    _titleController = TextEditingController(text: widget.expense?['title'] ?? '');
    _amountController = TextEditingController(text: widget.expense != null ? widget.expense!['amount'].toString() : '');
    _category = widget.expense?['category'] ?? 'Food';
    _date = widget.expense?['date'] != null ? DateTime.tryParse(widget.expense!['date']) ?? DateTime.now() : DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _saving = true; });
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedExpenses = prefs.getString('expenses');
      List<Map<String, dynamic>> expenses = [];
      if (storedExpenses != null && storedExpenses.isNotEmpty) {
        expenses = List<Map<String, dynamic>>.from(json.decode(storedExpenses));
      }
      final expenseData = {
        'id': widget.expense?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'amount': double.parse(_amountController.text.trim()),
        'category': _category,
        'date': _date.toIso8601String(),
      };
      if (_isEditing) {
        expenses = expenses.map((item) => item['id'] == widget.expense!['id'] ? expenseData : item).toList();
      } else {
        expenses.add(expenseData);
      }
      await prefs.setString('expenses', json.encode(expenses));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      final i18n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(i18n.translate('error') ?? 'Error'),
          content: Text(i18n.translate('saveError') ?? 'Failed to save expense. Please try again.'),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
        ),
      );
    } finally {
      setState(() { _saving = false; });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() { _date = picked; });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkMode ? const Color(0xFF1a202c) : const Color(0xFFf3f4f6),
      appBar: AppBar(
        title: Text(_isEditing ? (i18n.translate('updateExpense') ?? 'Update Expense') : (i18n.translate('addExpense') ?? 'Add Expense')),
        backgroundColor: darkMode ? const Color(0xFF2d3748) : Colors.white,
        foregroundColor: darkMode ? Colors.white : Colors.black,
        elevation: 3,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final padding = isLargeScreen ? 30.0 : 20.0;
          final titleFontSize = isLargeScreen ? 18.0 : 16.0;
          final inputFontSize = isLargeScreen ? 16.0 : 14.0;
          final spacing = isLargeScreen ? 20.0 : 15.0;
          
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInput(
                      label: i18n.translate('expenseTitle') ?? 'Expense Title',
                      hint: i18n.translate('enterTitle') ?? 'Enter expense title',
                      controller: _titleController,
                      isDarkMode: darkMode,
                      validator: (v) => v == null || v.trim().isEmpty ? (i18n.translate('fillAllFields') ?? 'Please fill in all fields correctly') : null,
                    ),
                    SizedBox(height: spacing),
                    CustomInput(
                      label: i18n.translate('amount') ?? 'Amount',
                      hint: i18n.translate('enterAmount') ?? 'Enter amount',
                      controller: _amountController,
                      isDarkMode: darkMode,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return i18n.translate('fillAllFields') ?? 'Please fill in all fields correctly';
                        final d = double.tryParse(v.trim());
                        return d == null ? (i18n.translate('fillAllFields') ?? 'Please fill in all fields correctly') : null;
                      },
                    ),
                    SizedBox(height: spacing),
                    Text(i18n.translate('category') ?? 'Category', 
                      style: _labelStyle(darkMode).copyWith(fontSize: titleFontSize)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 20 : 15, vertical: isLargeScreen ? 5 : 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFd1d5db)),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: DropdownButton<String>(
                        value: _category,
                        isExpanded: true,
                        underline: SizedBox(),
                        items: _categories.map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(i18n.translate(cat.toLowerCase()) ?? cat, 
                            style: TextStyle(fontSize: inputFontSize)),
                        )).toList(),
                        onChanged: (val) => setState(() { _category = val!; }),
                        style: TextStyle(fontSize: inputFontSize),
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(i18n.translate('date') ?? 'Date', 
                      style: _labelStyle(darkMode).copyWith(fontSize: titleFontSize)),
                    InkWell(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 20 : 15, horizontal: isLargeScreen ? 20 : 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFd1d5db)),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Text(
                          '${_date.day}/${_date.month}/${_date.year}',
                          style: TextStyle(fontSize: inputFontSize, color: const Color(0xFF374151)),
                        ),
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 35 : 25),
                    CustomButton(
                      onPressed: _saving ? () {} : _saveExpense,
                      text: _isEditing ? (i18n.translate('updateExpense') ?? 'Update Expense') : (i18n.translate('addExpense') ?? 'Add Expense'),
                      backgroundColor: const Color(0xFF3b82f6),
                      width: double.infinity,
                      height: isLargeScreen ? 50 : 45,
                      isDarkMode: darkMode,
                      isLoading: _saving,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle _labelStyle(bool darkMode) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: darkMode ? Colors.white : const Color(0xFF374151),
  );

  InputDecoration _inputDecoration(String hint, bool darkMode) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFd1d5db)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFd1d5db)),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  );
}
