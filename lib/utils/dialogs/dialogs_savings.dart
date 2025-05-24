import 'package:flutter/material.dart';

Future<String?> showInputDialog(BuildContext context, String title) async {
  String input = '';
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        keyboardType: TextInputType.number,
        onChanged: (val) => input = val,
        decoration: const InputDecoration(hintText: 'Enter amount'),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context, input),
        ),
      ],
    ),
  );
}

Future<bool> showConfirmDialog(BuildContext context, String message) async {
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
  ) ?? false;
}