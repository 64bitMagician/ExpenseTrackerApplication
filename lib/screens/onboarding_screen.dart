import 'package:expense_tracker/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dogNameController = TextEditingController();

  @override
  void dispose() {
    _dogNameController.dispose();
    super.dispose();
  }

  Future<void> _saveAnswer() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstDogName', _dogNameController.text.trim());
    await prefs.setBool('onboardingDone', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'What was the name of your first Dog?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dogNameController,
                decoration: const InputDecoration(
                  labelText: 'Dog\'s Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAnswer,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
