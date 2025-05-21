import 'package:flutter/material.dart';
import '../utils/csv_expense_manager.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Map<String, String>> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final data = await CsvExpenseManager.readExpenses();
    setState(() {
      _expenses = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expenses")),
      body: _expenses.isEmpty
          ? const Center(child: Text("No expenses yet."))
          : ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final e = _expenses[index];
          return ListTile(
            title: Text(e['name'] ?? ''),
            trailing: Text("\$${e['price']}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
          _loadExpenses(); // Refresh after return
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
