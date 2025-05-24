import 'package:flutter/material.dart';
import '../custom_widgets/savings_progress_indicator.dart';
import '../custom_widgets/savings_buttons.dart';
import '../utils/dialogs_savings.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  double _savings = 0;
  double _goal = 0;

  void _addToSavings() async {
    final amountStr = await showInputDialog(context, 'Add to Savings');
    if (amountStr == null) return;

    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) return;

    final newTotal = _savings + amount;

    if (_goal == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please set a savings goal before adding savings.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (newTotal > _goal) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You cannot enter an amount exceeding the set goal'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _savings = newTotal;
    });
  }

  void _setGoal() async {
    final goalStr = await showInputDialog(context, 'Set Savings Goal');
    if (goalStr == null) return;

    final newGoal = double.tryParse(goalStr);
    if (newGoal != null && newGoal >= 0) {
      if (newGoal < _savings) {
        final confirmed = await showConfirmDialog(
          context,
          'New goal is below current savings. Reset savings to $newGoal?',
        );
        if (!confirmed) return;
        setState(() {
          _goal = newGoal;
          _savings = newGoal;
        });
      } else {
        setState(() {
          _goal = newGoal;
        });
      }
    }
  }

  void _deleteGoal() {
    setState(() {
      _goal = 0;
      _savings = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_goal > 0) ? (_savings / _goal).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SavingsProgress(savings: _savings, goal: _goal, progress: progress),
              const SizedBox(height: 40),
              SavingsButtons(
                onAdd: _addToSavings,
                onSetGoal: _setGoal,
                onDeleteGoal: _deleteGoal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}