import 'package:flutter/material.dart';
import '../utils/csv_expense_manager.dart';
import '../utils/dialogs_expenses.dart';  // <-- Make sure this is correct
import '../custom_widgets/customizable_strings.dart';

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

  Future<void> _deleteExpense(int index) async {
    // Show confirmation dialog, wait for user response
    final confirmed = await showExpenseConfirmDialog(
      context,
      "Are you sure you want to delete this expense?",
    );

    // If user did NOT confirm, just return and do nothing
    if (!confirmed) return;

    // User confirmed: remove expense and update storage
    setState(() {
      _expenses.removeAt(index);
    });

    await CsvExpenseManager.writeExpenses(_expenses);
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
          final name = e['name'] ?? '';
          final price = e['price'] ?? '';

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
                  CustomizableString.expenseStrings(context, price, name),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteExpense(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await showAddExpenseDialog(context);
          if (newExpense != null) {
            await CsvExpenseManager.addExpense(newExpense);
            _loadExpenses();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
