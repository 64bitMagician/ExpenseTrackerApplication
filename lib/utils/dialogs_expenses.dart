import 'package:flutter/material.dart';

Future<Map<String, String>?> showAddExpenseDialog(BuildContext context) async {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false, // force user to tap buttons
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Expense Name',
                hintText: 'Enter expense name',
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'Enter price',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, null),
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              final name = nameController.text.trim();
              final unformatedPrice = priceController.text.trim();
              final priceAsDouble = double.tryParse(unformatedPrice.replaceAll(",", ".")) ?? 0;
              final price = priceAsDouble.toString();


              // Basic validation
              if (name.isEmpty || price.isEmpty) {
                // Optionally show a Snackbar or alert here about empty fields
                return;
              }
              if (double.tryParse(price) == null) {
                // Price not a valid number
                return;
              }

              Navigator.pop(context, {'name': name, 'price': price});
            },
          ),
        ],
      );
    },
  );
}

Future<bool> showExpenseConfirmDialog(BuildContext context, String message) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm'),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  ) ?? false; // Default to false if dialog dismissed
}
