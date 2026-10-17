import 'package:flutter/material.dart';
import '../utils/csv_income_manager.dart';
import '../utils/dialogs/dialogs.dart';
import '../custom_widgets/customizable_strings.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  List<Map<String, String>> _incomes = [];


  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    final data = await CsvIncomeManager.readIncomes();
    if (!mounted) return;
    setState(() {
      _incomes = data;
    });
  }

  Future<void> _addIncome() async {
    final entry = await showNameAmountDialog(
      context,
      title: 'Add Income',
      nameLabel: 'Name',
      amountLabel: 'Amount',
    );
    if (entry == null) return;

    // The dashboard recalculates the balance from the stored incomes, so saving is enough
    await CsvIncomeManager.addIncome({'name': entry.name, 'amount': entry.amount.toString()});
    //Refreshes the screen with the new income
    await _loadIncomes();
  }

  Future<void> _deleteIncome(int index) async {
    final confirmed = await showConfirmDialog(
      context,
      "Are you sure you want to delete this income?",
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
    );

    if (!confirmed) return;

    setState(() {
      _incomes.removeAt(index);
    });

    await CsvIncomeManager.writeIncomes(_incomes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Income")),
      body: _incomes.isEmpty
          ? const Center(child: Text("No incomes yet."))
          : ListView.builder(
        itemCount: _incomes.length,
        itemBuilder: (context, index) {
          final e = _incomes[index];
          final name = e['name'] ?? '';
          final amount = e['amount'] ?? '';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Expanded lets long names wrap instead of overflowing the row
                  Expanded(child: CustomizableString.entryText(context, amount, name)),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => _deleteIncome(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIncome,
        tooltip: 'Add Income',
        child: const Icon(Icons.add),
      ),
    );
  }
}
