import 'package:expense_tracker/appRoutes.dart';
import 'package:expense_tracker/screens/dashboardScreen.dart';
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
//DATA
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordSet = PasswordFileManager.storedPassword != null;

  // Load Password Method
  void _loadPassword() async {
    await PasswordFileManager.loadPassword();
    setState(() {});
    var password = PasswordFileManager.storedPassword;
    print("Password is: $password");
    isPasswordSet = PasswordFileManager.storedPassword != null;
    print("is password set?: $isPasswordSet");
  }


  @override
  void initState() {
    super.initState();
    _loadPassword();
    print("is password set?: $isPasswordSet");
  }



  @override
  Widget build(BuildContext context) {
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
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Enter Password')),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    isPasswordSet
                        ? () {
                          final bool validLogin = PasswordFileManager.handleLogin(_passwordController, context);
                          if(validLogin)
                            Navigator.pushNamed(context, AppRoutes.dashboardScreen);
                        }
                        : null,
                child: const Text("Login"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed:
                    isPasswordSet
                        ? null
                        : () async {
                          final Future<bool> setupValid = PasswordFileManager.handleSetupPassword(_passwordController, context);
                          if (await setupValid) {
                            setState(() {
                              isPasswordSet = true;
                            });
                            Navigator.pushNamed(context, AppRoutes.dashboardScreen);
                          }
                        },
                child: const Text('Setup Password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  PasswordFileManager.deletePasswordFile(context);
                  setState(() {
                    isPasswordSet = false;
                  });
                },
                child: const Text("Delete password.txt"),
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
