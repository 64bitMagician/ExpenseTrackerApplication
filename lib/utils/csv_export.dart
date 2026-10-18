import 'package:csv/csv.dart';
import 'money.dart';

/// One expense or income, independent of how it is stored.
typedef MoneyRecord = ({String name, double amount});

/// Builds the CSV that the user downloads. Unlike the stored data it always has a
/// header row and a "Name,Amount" column order, and amounts are written as plain
/// numbers with two decimals (e.g. 12.50) so spreadsheets can sum them.
String buildExportCsv(List<MoneyRecord> records) {
  final rows = <List<String>>[
    ['Name', 'Amount (EUR)'],
    ...records.map((r) => [r.name, roundToCents(r.amount).toStringAsFixed(2)]),
  ];
  return const ListToCsvConverter().convert(rows);
}

/// File name with the current date, e.g. "expenses_2026-10-18.csv".
String exportFileName(String prefix, DateTime date) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${prefix}_${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}.csv';
}
