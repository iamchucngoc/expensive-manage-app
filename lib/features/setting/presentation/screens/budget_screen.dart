import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Ngân sách")),

      body: const Center(
        child: Text(
          "Quản lý ngân sách",
        ),
      ),
    );
  }
}