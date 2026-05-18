// lib/features/report/presentation/widgets/expense_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../transaction/data/models/transaction_model.dart';

class ExpenseChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ExpenseChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Nhóm theo danh mục
    final Map<String, double> categoryTotal = {};
    for (var t in transactions) {
      if (t.type == TransactionType.expense) {
        categoryTotal[t.categoryName] = (categoryTotal[t.categoryName] ?? 0) + t.amount;
      }
    }

    if (categoryTotal.isEmpty) {
      return const Center(
        child: Text("Chưa có dữ liệu chi tiêu", style: TextStyle(fontSize: 16)),
      );
    }

    final List<PieChartSectionData> sections = [];
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.purple,
      Colors.blue,
      Colors.teal,
      Colors.pink,
    ];

    int colorIndex = 0;
    categoryTotal.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          value: amount,
          title: "${category}\n${amount.toInt()}đ",
          color: colors[colorIndex % colors.length],
          radius: 110,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Biểu đồ chi tiêu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}