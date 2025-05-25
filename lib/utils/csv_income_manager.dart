import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class CsvIncomeManager {
  static const String _fileName = "incomes.csv";

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$_fileName");
  }

  static Future<List<Map<String, String>>> readIncomes() async {
    final file = await _getFile();
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final rows = const CsvToListConverter().convert(content);

    return rows
        .map((row) => {
      'name': row[0].toString(),
      'amount': row[1].toString(),
    })
        .toList();
  }

  static Future<void> writeIncomes(List<Map<String, String>> incomes) async {
    final file = await _getFile();
    final rows = incomes.map((e) => [e['name'], e['amount']]).toList();
    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }

  static Future<void> addIncome(Map<String, String> income) async {
    final incomes = await readIncomes();
    incomes.add(income);
    await writeIncomes(incomes);
  }
}
