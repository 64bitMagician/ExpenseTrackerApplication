import 'package:shared_preferences/shared_preferences.dart';

import 'csv_expense_manager.dart';
import 'csv_income_manager.dart';
import 'money.dart';

const String savingsPrefsKey = 'savings';
const String goalPrefsKey = 'goal';

/// The balance is always derived from the stored records instead of being tracked
/// separately, so adding or deleting an entry can never leave it out of sync.
/// Summed in whole cents to avoid floating-point drift.
double computeBalance({
  required Iterable<double> incomes,
  required Iterable<double> expenses,
  double savings = 0,
}) {
  int toCents(double value) => (value * 100).round();
  final incomeCents = incomes.fold<int>(0, (sum, value) => sum + toCents(value));
  final expenseCents = expenses.fold<int>(0, (sum, value) => sum + toCents(value));
  return (incomeCents - expenseCents - toCents(savings)) / 100;
}

/// Current balance = all incomes - all expenses - money put aside in savings.
Future<double> loadCurrentBalance() async {
  final incomes = await CsvIncomeManager.readIncomes();
  final expenses = await CsvExpenseManager.readExpenses();
  final prefs = await SharedPreferences.getInstance();

  return computeBalance(
    incomes: incomes.map((e) => parseStoredAmount(e['amount'] ?? '')),
    expenses: expenses.map((e) => parseStoredAmount(e['price'] ?? '')),
    savings: prefs.getDouble(savingsPrefsKey) ?? 0,
  );
}
