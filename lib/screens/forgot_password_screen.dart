import 'package:expense_tracker/utils/password_file_management.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animations/password_hint_animation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _answerController = TextEditingController();
  late final String _correctAnswer;

  bool _showPasswordMessage = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  Future<void> fetchCorrectResponse() async {
    final prefs = await SharedPreferences.getInstance();
    _correctAnswer = prefs.getString('firstDogName')!;
  }

  String? fetchPassword(){
    String? password = PasswordFileManager.storedPassword;
    return password;
  }

  @override
  void initState() {
    super.initState();
    fetchPassword();
    fetchCorrectResponse();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _checkAnswer() {
    final input = _answerController.text.trim().toLowerCase();

    if (input == _correctAnswer.toLowerCase()) {
      setState(() {
        _showPasswordMessage = true;
      });
      _animationController.forward();
    } else {
      setState(() {
        _showPasswordMessage = false;
      });
      _animationController.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Incorrect answer. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _animationController.dispose();
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
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 32),
            if (_showPasswordMessage)
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: PasswordHintAnimation(fetchPassword()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}