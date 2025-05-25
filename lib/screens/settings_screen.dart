import 'package:flutter/material.dart';
import '../dataScreens/getExpensesCSVDataBaseWithinStorage.dart';
import '../dataScreens/getIncomesCSVDataBaseWithinStorage.dart'; // Add this line
import 'package:expense_tracker/appRoutes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            subtitle: const Text('Update your login credentials'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.changePasswordScreen);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Show Expenses CSV Database'),
            subtitle: const Text('View raw expenses stored in the app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CsvViewerScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Show Incomes CSV Database'),
            subtitle: const Text('View raw incomes stored in the app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CsvViewerIncomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
