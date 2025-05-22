import 'package:flutter/material.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'View and manage your savings here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
