import 'package:csv/csv.dart';
import 'package:expense_tracker/data_screens/records_table_screen.dart';
import 'package:expense_tracker/utils/csv_expense_manager.dart';
import 'package:expense_tracker/utils/csv_export.dart';
import 'package:expense_tracker/utils/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('buildExportCsv', () {
    test('adds a header and writes amounts with two decimals', () {
      final csv = buildExportCsv([(name: 'Coffee', amount: 2.5), (name: 'Rent', amount: 800)]);
      expect(csv, 'Name,Amount (EUR)\r\nCoffee,2.50\r\nRent,800.00');
    });

    test('quotes names with commas, quotes and line breaks so they survive a round trip', () {
      const name = 'Dinner, "Luigi\'s"\nwith friends';
      final rows = const CsvToListConverter(shouldParseNumbers: false)
          .convert(buildExportCsv([(name: name, amount: 42.1)]));
      expect(rows[1], [name, '42.10']);
    });

    test('an empty list still has the header', () {
      expect(buildExportCsv([]), 'Name,Amount (EUR)');
    });
  });

  test('exportFileName pads month and day', () {
    expect(exportFileName('expenses', DateTime(2026, 3, 7)), 'expenses_2026-03-07.csv');
  });

  group('RecordsTableScreen', () {
    testWidgets('shows stored expenses with formatted amounts and a total', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await CsvExpenseManager.writeExpenses([
        {'price': '12.5', 'name': 'Lunch'},
        {'price': '7.25', 'name': 'Bus'},
      ]);

      await tester.pumpWidget(MaterialApp(home: RecordsTableScreen.expenses()));
      await tester.pumpAndSettle();

      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text(formatMoney(12.5)), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text(formatMoney(19.75)), findsOneWidget);
      final exportButton = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.file_download));
      expect(exportButton.onPressed, isNotNull);
    });

    testWidgets('disables export when there is nothing to export', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(MaterialApp(home: RecordsTableScreen.incomes()));
      await tester.pumpAndSettle();

      expect(find.text('No data found'), findsOneWidget);
      final exportButton = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.file_download));
      expect(exportButton.onPressed, isNull);
    });
  });
}
