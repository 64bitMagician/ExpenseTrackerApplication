import 'package:expense_tracker/utils/change_password_validator.dart';
import 'package:expense_tracker/utils/custom_snackbar.dart';
import 'package:expense_tracker/utils/password_file_management.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final error = validatePasswordChange(
      storedPassword: PasswordFileManager.storedPassword,
      currentPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (error != null) {
      showReplacingSnackbar(context, error, color: Colors.red);
      return;
    }

    setState(() => _isSaving = true);
    // Wait for the password to be written before leaving the screen
    await PasswordFileManager.savePassword(_newPasswordController.text);
    if (!mounted) return;
    showReplacingSnackbar(context, "✅ Password Successfully Changed!", color: Colors.green);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _oldPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
            const SizedBox(height: 12),
            TextField(controller: _newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _isSaving ? null : _updatePassword, child: const Text('Update Password')),
          ],
        ),
      ),
    );
  }
}
