import 'package:flutter/material.dart';
import '../dataScreens/getCSVDataBaseWithinStorage.dart'; // Adjust if needed
import 'change_password_screen.dart';
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
            title: const Text('Show CSV Database'),
            subtitle: const Text('View raw data stored in the app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CsvViewerScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
