import 'package:flutter/material.dart';
import '../utils/csv_expense_manager.dart';

class CsvViewerScreen extends StatefulWidget {
  const CsvViewerScreen({super.key});

  @override
  State<CsvViewerScreen> createState() => _CsvViewerScreenState();
}

class _CsvViewerScreenState extends State<CsvViewerScreen> {
  List<Map<String, String>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadCsv();
  }

  Future<void> _loadCsv() async {
    final data = await CsvExpenseManager.readExpenses();
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('CSV Expenses Database')),
        body: Center(child: Text('No data found')),
      );
    }

    final columns = _data.first.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('CSV Expenses Database')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns
              .map((col) => DataColumn(label: Text(col.toUpperCase())))
              .toList(),
          rows: _data.map((row) {
            return DataRow(
              cells: columns.map((col) {
                return DataCell(Text(row[col] ?? ''));
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}

