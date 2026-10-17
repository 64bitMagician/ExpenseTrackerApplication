import 'package:expense_tracker/app_routes.dart';
import 'package:expense_tracker/utils/custom_snackbar.dart';
import 'package:expense_tracker/utils/password_validator.dart';
import 'package:flutter/material.dart';
import '../utils/password_file_management.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//DATA
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true; // both buttons stay disabled until we know if a password exists
  bool _isPasswordSet = false;

  // Load Password Method
  Future<void> _loadPassword() async {
    await PasswordFileManager.loadPassword();
    if (!mounted) return;
    setState(() {
      _isPasswordSet = PasswordFileManager.storedPassword != null;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPassword();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!PasswordFileManager.checkPassword(_passwordController.text)) {
      showReplacingSnackbar(context, "❌ Incorrect Password!");
      return;
    }
    showReplacingSnackbar(context, "✅ Login Successful!");
    // Replace the login screen so "back" from the dashboard leaves the app instead of returning here
    Navigator.pushReplacementNamed(context, AppRoutes.dashboardScreen);
  }

  Future<void> _setupPassword() async {
    final password = _passwordController.text;
    final validationMessage = PasswordValidator.validate(password);
    if (validationMessage != null) {
      showReplacingSnackbar(context, validationMessage, color: Colors.redAccent);
      return;
    }

    await PasswordFileManager.savePassword(password);
    if (!mounted) return;
    showReplacingSnackbar(context, "✅ Password Set Successfully!");
    Navigator.pushReplacementNamed(context, AppRoutes.dashboardScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.helpScreen);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Enter Password'),
                onSubmitted: (_) => !_isLoading && _isPasswordSet ? _login() : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: !_isLoading && _isPasswordSet ? _login : null,
                child: const Text("Login"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: !_isLoading && !_isPasswordSet ? _setupPassword : null,
                child: const Text('Setup Password'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
                },
                child: const Text("Forgot your password?", style: TextStyle(decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
