import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Incomes are kept as CSV text in SharedPreferences, which works on mobile,
/// desktop and web (where it is backed by the browser's localStorage).
class CsvIncomeManager {
  static const String prefsKey = 'incomes_csv';

  static Future<List<Map<String, String>>> readIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(prefsKey);
    if (content == null) return [];

    // Keep every field as text, otherwise a name like "007" would be read back as "7".
    final rows = const CsvToListConverter(shouldParseNumbers: false).convert(content);

    return rows
        .where((row) => row.length >= 2)
        .map((row) => {
      'name': row[0].toString(),
      'amount': row[1].toString(),
    })
        .toList();
  }

  static Future<void> writeIncomes(List<Map<String, String>> incomes) async {
    final rows = incomes.map((e) => [e['name'], e['amount']]).toList();
    final csv = const ListToCsvConverter().convert(rows);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, csv);
  }

  static Future<void> addIncome(Map<String, String> income) async {
    final incomes = await readIncomes();
    incomes.add(income);
    await writeIncomes(incomes);
  }
}
