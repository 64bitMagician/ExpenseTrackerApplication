import 'dart:io';

import 'package:expense_tracker/utils/balance.dart';
import 'package:expense_tracker/utils/csv_expense_manager.dart';
import 'package:expense_tracker/utils/csv_income_manager.dart';
import 'package:expense_tracker/utils/legacy_migration.dart';
import 'package:expense_tracker/utils/password_file_management.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('CSV managers', () {
    test('round-trip expenses, keeping names with commas, quotes and digits intact', () async {
      final expenses = [
        {'price': '12.5', 'name': 'Coffee, "large"'},
        {'price': '3.0', 'name': '007'},
      ];
      await CsvExpenseManager.writeExpenses(expenses);
      expect(await CsvExpenseManager.readExpenses(), expenses);
    });

    test('add and delete incomes', () async {
      await CsvIncomeManager.addIncome({'name': 'Salary', 'amount': '1500.0'});
      await CsvIncomeManager.addIncome({'name': 'Gift', 'amount': '50.0'});
      final incomes = await CsvIncomeManager.readIncomes()..removeAt(0);
      await CsvIncomeManager.writeIncomes(incomes);
      expect(await CsvIncomeManager.readIncomes(), [{'name': 'Gift', 'amount': '50.0'}]);
    });

    test('an empty list reads back as empty', () async {
      await CsvExpenseManager.writeExpenses([]);
      expect(await CsvExpenseManager.readExpenses(), isEmpty);
    });
  });

  test('loadCurrentBalance combines incomes, expenses and savings', () async {
    SharedPreferences.setMockInitialValues({savingsPrefsKey: 100.0});
    await CsvIncomeManager.addIncome({'name': 'Salary', 'amount': '1000.0'});
    await CsvExpenseManager.addExpense({'price': '250.5', 'name': 'Rent'});
    expect(await loadCurrentBalance(), 649.5);
  });

  group('PasswordFileManager', () {
    test('saves, loads and checks the password', () async {
      await PasswordFileManager.savePassword('secret123!');
      PasswordFileManager.storedPassword = null;
      await PasswordFileManager.loadPassword();
      expect(PasswordFileManager.checkPassword('secret123!'), isTrue);
      expect(PasswordFileManager.checkPassword('wrong'), isFalse);
    });

    test('treats a blank stored password as not set', () async {
      SharedPreferences.setMockInitialValues({PasswordFileManager.prefsKey: '   '});
      await PasswordFileManager.loadPassword();
      expect(PasswordFileManager.storedPassword, isNull);
    });
  });

  group('migrateLegacyFiles', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('legacy_migration_test'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('moves old files into SharedPreferences and deletes them', () async {
      File('${dir.path}/expenses.csv').writeAsStringSync('12.5,Coffee\r\n3.0,Bus');
      File('${dir.path}/incomes.csv').writeAsStringSync('Salary,1500');
      File('${dir.path}/password.txt').writeAsStringSync('secret123!');

      await migrateLegacyFiles(dir);

      expect(await CsvExpenseManager.readExpenses(), [
        {'price': '12.5', 'name': 'Coffee'},
        {'price': '3.0', 'name': 'Bus'},
      ]);
      expect(await CsvIncomeManager.readIncomes(), [{'name': 'Salary', 'amount': '1500'}]);
      await PasswordFileManager.loadPassword();
      expect(PasswordFileManager.storedPassword, 'secret123!');
      expect(dir.listSync(), isEmpty);
    });

    test('never overwrites data already in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({PasswordFileManager.prefsKey: 'newPassword1!'});
      File('${dir.path}/password.txt').writeAsStringSync('oldPassword1!');

      await migrateLegacyFiles(dir);

      await PasswordFileManager.loadPassword();
      expect(PasswordFileManager.storedPassword, 'newPassword1!');
      expect(File('${dir.path}/password.txt').existsSync(), isFalse);
    });

    test('does nothing when there are no legacy files', () async {
      await migrateLegacyFiles(dir);
      expect(await CsvExpenseManager.readExpenses(), isEmpty);
    });
  });
}
