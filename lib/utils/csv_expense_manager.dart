import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CsvExpenseManager {
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/expenses.csv';
    return File(path);
  }

  static Future<void> addExpense(String name, String price) async {
    final file = await _getFile();
    final exists = await file.exists();
    if (!exists) await file.create(recursive: true);
    await file.writeAsString('$name,$price\n', mode: FileMode.append);
  }

  static Future<List<Map<String, String>>> readExpenses() async {
    final file = await _getFile();
    final exists = await file.exists();
    if (!exists) return [];

    final lines = await file.readAsLines();
    return lines.map((line) {
      final parts = line.split(',');
      return {'name': parts[0], 'price': parts[1]};
    }).toList();
  }
}
