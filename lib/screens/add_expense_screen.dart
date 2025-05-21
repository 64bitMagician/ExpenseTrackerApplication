import 'package:flutter/material.dart';
import '../utils/csv_expense_manager.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  Future<void> _saveExpense() async {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    if (name.isNotEmpty && price.isNotEmpty) {
      await CsvExpenseManager.addExpense(name, price);
      Navigator.pop(context); // Go back to Expenses screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Expense Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveExpense,
              child: const Text("Save Expense"),
            )
          ],
        ),
      ),
    );
  }
}
