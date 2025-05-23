import 'package:flutter/material.dart';

class SavingsButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onSetGoal;
  final VoidCallback onDeleteGoal;

  const SavingsButtons({
    super.key,
    required this.onAdd,
    required this.onSetGoal,
    required this.onDeleteGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onAdd,
          child: const Text('Add to Savings'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onSetGoal,
          child: const Text('Set Savings Goal'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onDeleteGoal,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete Savings Goal'),
        ),
      ],
    );
  }
}
