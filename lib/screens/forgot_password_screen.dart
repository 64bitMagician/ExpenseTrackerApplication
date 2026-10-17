import 'package:expense_tracker/utils/custom_snackbar.dart';
import 'package:expense_tracker/utils/password_file_management.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animations/password_hint_animation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _answerController = TextEditingController();
  String? _correctAnswer; // null until loaded, or if onboarding never saved one

  bool _showPasswordMessage = false;

  Future<void> _fetchCorrectResponse() async {
    final prefs = await SharedPreferences.getInstance();
    _correctAnswer = prefs.getString('firstDogName');
  }

  @override
  void initState() {
    super.initState();
    _fetchCorrectResponse();
  }

  void _checkAnswer() {
    final input = _answerController.text.trim().toLowerCase();
    final isCorrect = _correctAnswer != null && input == _correctAnswer!.toLowerCase();

    setState(() {
      _showPasswordMessage = isCorrect;
    });
    if (!isCorrect) {
      showReplacingSnackbar(context, '❌ Incorrect answer. Try again.', color: Colors.redAccent);
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "What was the name of your first dog?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 32),
            // PasswordHintAnimation slides and fades itself in
            if (_showPasswordMessage) PasswordHintAnimation(PasswordFileManager.storedPassword),
          ],
        ),
      ),
    );
  }
}
