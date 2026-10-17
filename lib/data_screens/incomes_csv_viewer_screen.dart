import 'package:flutter/material.dart';
import '../utils/csv_income_manager.dart';

class CsvViewerIncomeScreen extends StatefulWidget {
  const CsvViewerIncomeScreen({super.key});

  @override
  State<CsvViewerIncomeScreen> createState() => _CsvViewerIncomeScreenState();
}

class _CsvViewerIncomeScreenState extends State<CsvViewerIncomeScreen> {
  List<Map<String, String>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadCsv();
  }

  Future<void> _loadCsv() async {
    final data = await CsvIncomeManager.readIncomes();
    if (!mounted) return;
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('CSV Incomes Database')),
        body: const Center(child: Text('No income data found')),
      );
    }

    final columns = _data.first.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('CSV Incomes Database')),
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
