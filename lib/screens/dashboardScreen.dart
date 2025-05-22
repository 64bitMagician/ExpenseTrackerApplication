import 'package:flutter/material.dart';
import '../custom_widgets/DashboardCard.dart';
import 'help_screen.dart'; // Make sure this file exists or create it

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  DashboardCard(title: 'Expenses', icon: Icons.money_off),
                  DashboardCard(title: 'Income', icon: Icons.attach_money),
                  DashboardCard(title: 'Settings', icon: Icons.settings),
                  DashboardCard(title: 'Savings', icon: Icons.savings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
