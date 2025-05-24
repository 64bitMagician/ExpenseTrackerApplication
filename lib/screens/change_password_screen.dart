import 'package:expense_tracker/utils/change_password_validator.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/password_file_management.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: oldPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
            const SizedBox(height: 12),
            TextField(controller: newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {validatePasswordChange(context, oldPasswordController.text, newPasswordController.text);}, child: const Text('Update Password')),
          ],
        ),
      ),
    );
  }
}
