import 'package:expense_tracker/appRoutes.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/DashboardCard.dart';
import 'help_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  static double balance = 200;

  DashboardScreen({super.key});

  static void extractFromBalance(double money) {
    balance -= money;
  }

  static void addToBalance(double money){
    balance += money;
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
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
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Balance',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${DashboardScreen.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.expensesScreen)
                          .then((_) => setState(() {})); // Rebuild when returning
                    },
                  ),
                  DashboardCard(
                    title: 'Income',
                    icon: Icons.attach_money,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.incomeScreen)
                          .then((_) => setState(() {}));
                    },
                  ),
                  DashboardCard(
                    title: 'Settings',
                    icon: Icons.settings,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.settingsScreen)
                          .then((_) => setState(() {}));
                    },
                  ),
                  DashboardCard(
                    title: 'Savings',
                    icon: Icons.savings,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.savingsScreen)
                          .then((_) => setState(() {}));
                    },
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
