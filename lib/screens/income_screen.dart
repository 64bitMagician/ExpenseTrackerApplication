import 'package:flutter/material.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Track your income here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
