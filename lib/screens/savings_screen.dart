import 'package:flutter/material.dart';
import '../custom_widgets/savings_progress_indicator.dart';
import '../custom_widgets/savings_buttons.dart';
import '../utils/balance.dart';
import '../utils/custom_snackbar.dart';
import '../utils/dialogs/dialogs.dart';
import '../utils/money.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  // Money in savings is subtracted from the current balance (see loadCurrentBalance),
  // so resetting savings to 0 automatically returns that money to the balance.
  double _savings = 0;
  double _goal = 0;

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(savingsPrefsKey, _savings);
    await prefs.setDouble(goalPrefsKey, _goal);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _savings = prefs.getDouble(savingsPrefsKey) ?? 0.0;
      _goal = prefs.getDouble(goalPrefsKey) ?? 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  void _showError(String message) => showReplacingSnackbar(context, message, color: Colors.red);

  Future<void> _addToSavings() async {
    if (_goal == 0) {
      _showError('Please set a savings goal before adding savings.');
      return;
    }

    final amount = await showAmountDialog(context, 'Add to Savings');
    if (amount == null || !mounted) return;

    final newTotal = roundToCents(_savings + amount);
    if (newTotal > _goal) {
      _showError('You cannot enter an amount exceeding the set goal');
      return;
    }

    final balance = await loadCurrentBalance();
    if (!mounted) return;
    if (amount > balance) {
      _showError('Not enough balance. You have ${formatMoney(balance)} available.');
      return;
    }

    // If reached here, then the adding of funds is valid
    setState(() {
      _savings = newTotal;
    });
    await _saveToPrefs();
  }

  Future<void> _setGoal() async {
    final newGoal = await showAmountDialog(context, 'Set Savings Goal');
    if (newGoal == null || !mounted) return;

    if (newGoal < _savings) {
      final confirmed = await showConfirmDialog(
        context,
        'The new goal is below your current savings. '
        'Reset savings to 0 and return ${formatMoney(_savings)} to your balance?',
      );
      if (!confirmed) return;
      setState(() {
        _goal = newGoal;
        _savings = 0;
      });
    } else {
      setState(() {
        _goal = newGoal;
      });
    }
    await _saveToPrefs();
  }

  Future<void> _deleteGoal() async {
    if (_goal == 0 && _savings == 0) return;

    final confirmed = await showConfirmDialog(
      context,
      _savings > 0
          ? 'Delete the savings goal? ${formatMoney(_savings)} will return to your balance.'
          : 'Delete the savings goal?',
    );
    if (!confirmed) return;

    setState(() {
      _goal = 0;
      _savings = 0;
    });
    await _saveToPrefs();
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
