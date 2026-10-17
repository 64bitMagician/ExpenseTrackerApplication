import 'package:expense_tracker/app_routes.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/dashboard_card.dart';
import '../utils/balance.dart';
import '../utils/money.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Data
  double? _balance; // null until loaded

  //Methods
  Future<void> _refreshBalance() async {
    final balance = await loadCurrentBalance();
    if (!mounted) return;
    setState(() {
      _balance = balance;
    });
  }

  // Open a feature screen and recalculate the balance when coming back from it
  void _open(String route) {
    Navigator.pushNamed(context, route).then((_) => _refreshBalance());
  }

  @override
  void initState() {
    super.initState();
    _refreshBalance();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final balance = _balance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.helpScreen),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: colorScheme.secondaryContainer,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(fontSize: 16, color: colorScheme.onSecondaryContainer),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        balance == null ? '…' : formatMoney(balance),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: (balance ?? 0) < 0 ? colorScheme.error : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  DashboardCard(
                    title: 'Expenses',
                    icon: Icons.money_off,
                    onPressed: () => _open(AppRoutes.expensesScreen),
                  ),
                  DashboardCard(
                    title: 'Income',
                    icon: Icons.attach_money,
                    onPressed: () => _open(AppRoutes.incomeScreen),
                  ),
                  DashboardCard(
                    title: 'Settings',
                    icon: Icons.settings,
                    onPressed: () => _open(AppRoutes.settingsScreen),
                  ),
                  DashboardCard(
                    title: 'Savings',
                    icon: Icons.savings,
                    onPressed: () => _open(AppRoutes.savingsScreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
