import 'package:flutter/material.dart';
import '../utils/csv_income_manager.dart';
import '../utils/dialogs/dialogs_incomes.dart';
import '../custom_widgets/customizable_strings.dart';
import '../utils/dialogs/dialogs_incomes.dart';

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
    setState(() {
      _incomes = data;
    });
  }

  Future<void> _deleteIncome(int index) async {
    final confirmed = await showIncomeConfirmDialog(
      context,
      "Are you sure you want to delete this income?",
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
                  CustomizableString.expenseStrings(context, amount, name),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteIncome(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newIncome = await showAddIncomeDialog(context);
          if (newIncome != null) {
            await CsvIncomeManager.addIncome(newIncome);
            _loadIncomes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
