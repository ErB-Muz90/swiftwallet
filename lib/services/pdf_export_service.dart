import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:swiftwallet/models/expense.dart';
import 'package:swiftwallet/models/budget.dart';

class PdfExportService {
  static Future<String?> exportExpensesToPdf(
    List<Expense> expenses,
    List<Budget> budgets,
    String currency,
  ) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text(
                'SwiftWallet Expense Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              _buildExpensesTable(expenses, currency),
              pw.SizedBox(height: 30),
              _buildBudgetsTable(budgets, currency),
              pw.SizedBox(height: 20),
              pw.Text(
                'Generated on: ${DateTime.now()}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );

      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/expense_report.pdf');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      print('Error exporting PDF: $e');
      return null;
    }
  }

  static pw.Widget _buildExpensesTable(List<Expense> expenses, String currency) {
    return pw.Table.fromTextArray(
      headers: ['Date', 'Title', 'Category', 'Amount'],
      data: [
        for (var expense in expenses)
          [
            expense.date.toString().split(' ')[0],
            expense.title,
            expense.category,
            '$currency ${expense.amount.toStringAsFixed(2)}',
          ]
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: pw.TextStyle(fontSize: 10),
    );
  }

  static pw.Widget _buildBudgetsTable(List<Budget> budgets, String currency) {
    return pw.Table.fromTextArray(
      headers: ['Name', 'Period', 'Amount'],
      data: [
        for (var budget in budgets)
          [
            budget.name,
            '${budget.startDate.toString().split(' ')[0]} - ${budget.endDate.toString().split(' ')[0]}',
            '$currency ${budget.amount.toStringAsFixed(2)}',
          ]
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: pw.TextStyle(fontSize: 10),
    );
  }
}
