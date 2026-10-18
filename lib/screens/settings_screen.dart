import 'package:flutter/material.dart';
import '../data_screens/records_table_screen.dart';
import 'package:expense_tracker/app_routes.dart';

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
            title: const Text('Expenses Data'),
            subtitle: const Text('View all expenses and export them as CSV'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecordsTableScreen.expenses(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Incomes Data'),
            subtitle: const Text('View all incomes and export them as CSV'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecordsTableScreen.incomes(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
