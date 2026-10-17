import 'package:flutter/material.dart';

import '../money.dart';

/// Asks for a name and a positive amount (used for both expenses and incomes).
/// Returns null if the user cancels.
Future<({String name, double amount})?> showNameAmountDialog(
  BuildContext context, {
  required String title,
  required String nameLabel,
  required String amountLabel,
}) {
  return showDialog<({String name, double amount})>(
    context: context,
    barrierDismissible: false, // force user to tap buttons
    builder: (_) => _NameAmountDialog(title: title, nameLabel: nameLabel, amountLabel: amountLabel),
  );
}

/// Asks for a single positive amount. Returns null if the user cancels.
Future<double?> showAmountDialog(BuildContext context, String title) {
  return showDialog<double>(
    context: context,
    builder: (_) => _NameAmountDialog(title: title, amountLabel: 'Amount'),
  );
}

Future<bool> showConfirmDialog(
  BuildContext context,
  String message, {
  String confirmLabel = 'Yes',
  String cancelLabel = 'No',
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(cancelLabel),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              child: Text(confirmLabel),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ) ??
      false; // Default to false if dialog dismissed
}

/// Without a [nameLabel] only the amount is asked for, and the dialog pops a plain double.
class _NameAmountDialog extends StatefulWidget {
  final String title;
  final String? nameLabel;
  final String amountLabel;

  const _NameAmountDialog({required this.title, this.nameLabel, required this.amountLabel});

  @override
  State<_NameAmountDialog> createState() => _NameAmountDialogState();
}

class _NameAmountDialogState extends State<_NameAmountDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _nameError;
  String? _amountError;

  bool get _asksForName => widget.nameLabel != null;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final amount = parseAmount(_amountController.text);

    setState(() {
      _nameError = _asksForName && name.isEmpty ? 'Please enter a name' : null;
      _amountError = amount == null ? 'Enter a positive number, e.g. 12,50' : null;
    });
    if (_nameError != null || amount == null) return;

    Navigator.pop(context, _asksForName ? (name: name, amount: amount) : amount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_asksForName)
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: widget.nameLabel, errorText: _nameError),
            ),
          TextField(
            controller: _amountController,
            autofocus: !_asksForName,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: widget.amountLabel, errorText: _amountError),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
