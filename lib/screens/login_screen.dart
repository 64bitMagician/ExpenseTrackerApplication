import 'package:expense_tracker/screens/dashboard.dart';
import 'package:expense_tracker/screens/help_screen.dart'; // Add this import
import 'package:flutter/material.dart';
import 'forgot_password_screen.dart'; // Adjust path as needed
import '../utils/password_file_management.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PasswordFileManager.loadPassword();
  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordSet = PasswordFileManager.storedPassword != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isPasswordSet
                    ? () {
                  PasswordFileManager.handleLogin(_passwordController, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                }
                    : null,
                child: const Text("Login"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isPasswordSet
                    ? null
                    : () {
                  PasswordFileManager.handleSetupPassword(_passwordController, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
                child: const Text('Setup Password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  PasswordFileManager.deletePasswordFile(context);
                  setState(() {
                    // This forces UI rebuild to update isPasswordSet
                  });
                },
                child: const Text("Delete password.txt"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  );
                },
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
