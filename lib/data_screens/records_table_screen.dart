import 'package:flutter/material.dart';
import '../utils/csv_expense_manager.dart';
import '../utils/csv_income_manager.dart';
import '../utils/csv_export.dart';
import '../utils/custom_snackbar.dart';
import '../utils/file_export/file_export.dart';
import '../utils/money.dart';

/// Shows all stored expenses or incomes as a table, with a button to export them as CSV.
class RecordsTableScreen extends StatefulWidget {
  final String title;
  final String filePrefix;
  final Future<List<MoneyRecord>> Function() loadRecords;

  const RecordsTableScreen({
    super.key,
    required this.title,
    required this.filePrefix,
    required this.loadRecords,
  });

  factory RecordsTableScreen.expenses({Key? key}) => RecordsTableScreen(
        key: key,
        title: 'Expenses Data',
        filePrefix: 'expenses',
        loadRecords: () async => (await CsvExpenseManager.readExpenses())
            .map((e) => (name: e['name'] ?? '', amount: parseStoredAmount(e['price'] ?? '')))
            .toList(),
      );

  factory RecordsTableScreen.incomes({Key? key}) => RecordsTableScreen(
        key: key,
        title: 'Incomes Data',
        filePrefix: 'incomes',
        loadRecords: () async => (await CsvIncomeManager.readIncomes())
            .map((e) => (name: e['name'] ?? '', amount: parseStoredAmount(e['amount'] ?? '')))
            .toList(),
      );

  @override
  State<RecordsTableScreen> createState() => _RecordsTableScreenState();
}

class _RecordsTableScreenState extends State<RecordsTableScreen> {
  List<MoneyRecord>? _records; // null until loaded

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await widget.loadRecords();
    if (!mounted) return;
    setState(() {
      _records = records;
    });
  }

  Future<void> _export(List<MoneyRecord> records) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    try {
      await exportCsvFile(
        exportFileName(widget.filePrefix, DateTime.now()),
        buildExportCsv(records),
        origin: origin,
      );
    } catch (_) {
      if (!mounted) return;
      showReplacingSnackbar(context, '❌ Export failed', color: Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _records;
    final total = records == null
        ? 0.0
        : roundToCents(records.fold(0.0, (sum, r) => sum + r.amount));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export CSV',
            onPressed: records == null || records.isEmpty ? null : () => _export(records),
          ),
        ],
      ),
      body: records == null
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? const Center(child: Text('No data found'))
              : SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('NAME')),
                        DataColumn(label: Text('AMOUNT'), numeric: true),
                      ],
                      rows: [
                        ...records.map((r) => DataRow(cells: [
                              DataCell(Text(r.name)),
                              DataCell(Text(formatMoney(r.amount))),
                            ])),
                        DataRow(cells: [
                          const DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatMoney(total),
                              style: const TextStyle(fontWeight: FontWeight.bold))),
                        ]),
                      ],
                    ),
                  ),
                ),
    );
  }
}
