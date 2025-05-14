import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/password_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String? storedPassword;

  @override
  void initState() {
    super.initState();
    _readPassword();
  }

  // This _localPath function is a getter function. It will fetch and return the directory documents directory path of the device
  // It returns the path as a Future String Object.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // This _passwordFile function is a getter function. It will fetch the storage path of the device
  //and after that, create an empty text file in that directotry.
  // It returns a Future File Object.
  Future<File> get _passwordFile async {
    final path = await _localPath;
    return File('$path/password.txt');
  }

  // This function will try to read the password that exists within the device's file system
  Future<void> _readPassword() async {
    try {
      final file = await _passwordFile; // fetches the newly created password file
      if (await file.exists()) { //it waits to see if the file exists
        storedPassword = await file.readAsString(); // read the password from the file
      }
      // TO DO
      setState(() {});
    } catch (e) {
      print("Error reading password: $e");
    }
  }

  Future<void> _writePassword(String password) async {
    final file = await _passwordFile;
    await file.writeAsString(password);
    storedPassword = password;
    setState(() {});
  }

  void _handleLogin() {
    if (_passwordController.text == storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login Successful!'),
      ));
      // TODO: Navigate to home screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Incorrect Password!'),
      ));
    }
  }

  void _handleSetupPassword() async {
    final password = _passwordController.text;
    final validationMessage = PasswordValidator.validate(password);

    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(validationMessage),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    await _writePassword(password);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password Set Successfully!'),
    ));
  }


  @override
  Widget build(BuildContext context) {
    final isPasswordSet = storedPassword != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
                decoration: const InputDecoration(
                  labelText: 'Enter Password',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isPasswordSet ? _handleLogin : null,
                child: const Text('Login'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isPasswordSet ? null : _handleSetupPassword,
                child: const Text('Setup Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
