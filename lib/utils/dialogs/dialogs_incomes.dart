import 'package:flutter/material.dart';

Future<Map<String, String>?> showAddIncomeDialog(BuildContext context) async {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add Income"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final amount = amountController.text.trim();

            if (name.isEmpty || amount.isEmpty) {
              Navigator.pop(context, null);
              return;
            }

            Navigator.pop(context, {'name': name, 'amount': amount});
          },
          child: const Text("Add"),
        ),
      ],
    ),
  );
}

Future<bool> showIncomeConfirmDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Delete"),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
