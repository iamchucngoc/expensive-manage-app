// lib/features/calendar/presentation/widgets/monthly_summary.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';

class MonthlySummary extends StatelessWidget {
  final List<TransactionModel> transactions;

  const MonthlySummary({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    double income = 0;
    double expense = 0;

    for (final item in transactions) {
      if (item.type == TransactionType.income) {
        income += item.amount;
      } else {
        expense += item.amount;
      }
    }

    final total = income - expense;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Thu nhập
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thu nhập',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${income.toInt()} đ',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // Chi tiêu
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Chi tiêu',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${expense.toInt()} đ',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // Tổng
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Tổng',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${total.toInt()} đ',
                style: TextStyle(
                  color: total < 0 ? Colors.red : Colors.blue, // Tổng âm thì đỏ, dương thì xanh
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}