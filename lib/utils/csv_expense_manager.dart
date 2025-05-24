import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class CsvExpenseManager {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/expenses.csv');
  }

  static Future<List<Map<String, String>>> readExpenses() async {
    final file = await _getFile();
    if (!await file.exists()) return [];

    final contents = await file.readAsString();
    final rows = const CsvToListConverter().convert(contents);

    return rows.map((row) {
      return {
        'price': row[0].toString(),
        'name': row[1].toString(),
      };
    }).toList();
  }

  static Future<void> writeExpenses(List<Map<String, String>> expenses) async {
    final file = await _getFile();
    final rows = expenses.map((e) => [e['price'], e['name']]).toList();
    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }

  static Future<void> addExpense(Map<String, String> expense) async {
    final expenses = await readExpenses();
    expenses.add(expense);
    await writeExpenses(expenses);
  }
}
