import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swiftwallet/models/expense.dart';
import 'package:swiftwallet/models/budget.dart';
import 'package:swiftwallet/services/pdf_export_service.dart';

class ExportService {
  static Future<bool> exportExpensesToCsv(
    List<Expense> expenses,
    List<Budget> budgets,
    String currency,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/expense_report.csv');
      
      // Create CSV content
      final buffer = StringBuffer();
      buffer.writeln('Date,Title,Category,Amount');
      
      for (var expense in expenses) {
        buffer.writeln(
          '${expense.date.toString().split(' ')[0]},'
          '${expense.title},'
          '${expense.category},'
          '${expense.amount.toStringAsFixed(2)}'
        );
      }
      
      buffer.writeln();
      buffer.writeln('Budget Name,Start Date,End Date,Amount');
      
      for (var budget in budgets) {
        buffer.writeln(
          '${budget.name},'
          '${budget.startDate.toString().split(' ')[0]},'
          '${budget.endDate.toString().split(' ')[0]},'
          '${budget.amount.toStringAsFixed(2)}'
        );
      }
      
      await file.writeAsString(buffer.toString());
      
      // Share the file
      await Share.shareFiles([file.path]);
      return true;
    } catch (e) {
      print('Error exporting CSV: $e');
      return false;
    }
  }
  
  static Future<bool> exportExpensesToPdf(
    List<Expense> expenses,
    List<Budget> budgets,
    String currency,
  ) async {
    try {
      final filePath = await PdfExportService.exportExpensesToPdf(
        expenses,
        budgets,
        currency,
      );
      
      if (filePath != null) {
        // Share the file
        await Share.shareFiles([filePath]);
        return true;
      }
      return false;
    } catch (e) {
      print('Error exporting PDF: $e');
      return false;
    }
  }
}
