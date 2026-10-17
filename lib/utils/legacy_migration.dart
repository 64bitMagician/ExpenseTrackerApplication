import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'csv_expense_manager.dart';
import 'csv_income_manager.dart';
import 'password_file_management.dart';

/// Older versions of the app stored data as files in the documents directory.
/// Maps each legacy file name to the SharedPreferences key that replaces it.
const Map<String, String> legacyFileKeys = {
  'expenses.csv': CsvExpenseManager.prefsKey,
  'incomes.csv': CsvIncomeManager.prefsKey,
  'password.txt': PasswordFileManager.prefsKey,
};

/// Copies data from the legacy files in [directory] into SharedPreferences and deletes
/// the files. Safe to run on every start: a value already in SharedPreferences is never
/// overwritten, and if the app stops halfway the remaining files are handled next time.
Future<void> migrateLegacyFiles(Directory directory) async {
  final prefs = await SharedPreferences.getInstance();

  for (final entry in legacyFileKeys.entries) {
    final file = File('${directory.path}/${entry.key}');
    if (!await file.exists()) continue;

    if (prefs.getString(entry.value) == null) {
      await prefs.setString(entry.value, await file.readAsString());
    }
    await file.delete();
  }

  // Left behind if an earlier version crashed while changing the password
  final tempPasswordFile = File('${directory.path}/password.txt.tmp');
  if (await tempPasswordFile.exists()) await tempPasswordFile.delete();
}
