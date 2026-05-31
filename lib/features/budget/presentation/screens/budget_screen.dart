// lib/features/budget/presentation/screens/budget_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/budget_model.dart';
import '../../data/services/budget_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() =>
      _BudgetScreenState();
}

class _BudgetScreenState
    extends State<BudgetScreen> {
  final controller =
      TextEditingController();

  Future<void> saveBudget() async {
    final amount =
        double.tryParse(
          controller.text,
        ) ??
        0;

    final now = DateTime.now();

    final budget = BudgetModel(
      id:
          "${now.month}-${now.year}",

      amount: amount,

      month: now.month,

      year: now.year,
    );

    await BudgetService()
        .saveBudget(budget);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Lưu ngân sách thành công",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Ngân sách"),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: controller,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Ngân sách tháng",
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: saveBudget,

                child: const Text(
                  "Lưu ngân sách",
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: StreamBuilder<
                  List<BudgetModel>>(
                stream:
                    BudgetService()
                        .getBudgets(),

                builder: (
                  context,
                  snapshot,
                ) {
                  if (!snapshot
                      .hasData) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final budgets =
                      snapshot.data!;

                  return ListView.builder(
                    itemCount:
                        budgets.length,

                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final budget =
                          budgets[index];

                      return Card(
                        child: ListTile(
                          title: Text(
                            "Tháng ${budget.month}/${budget.year}",
                          ),

                          subtitle: Text(
                            "${budget.amount.toStringAsFixed(0)} đ",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}