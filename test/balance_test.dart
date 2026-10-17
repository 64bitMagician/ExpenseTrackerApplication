import 'package:expense_tracker/utils/balance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeBalance', () {
    test('is 0 with no records', () {
      expect(computeBalance(incomes: [], expenses: []), 0);
    });

    test('subtracts expenses and savings from incomes', () {
      expect(computeBalance(incomes: [1000, 250.5], expenses: [99.99, 50], savings: 100), 1000.51);
    });

    test('can go negative', () {
      expect(computeBalance(incomes: [10], expenses: [25]), -15);
    });

    test('does not accumulate floating-point drift', () {
      // Summing 0.1 ten times as doubles gives 0.9999999999999999
      expect(computeBalance(incomes: List.filled(10, 0.1), expenses: []), 1.0);
      expect(computeBalance(incomes: [0.3], expenses: [0.1, 0.2]), 0);
    });

    test('deleting a record changes the balance by exactly its amount', () {
      final expenses = [12.5, 7.25];
      final before = computeBalance(incomes: [100], expenses: expenses);
      final after = computeBalance(incomes: [100], expenses: expenses..removeAt(0));
      expect(after - before, 12.5);
    });
  });
}
