// lib/features/calendar/presentation/widgets/monthly_summary.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';

class MonthlySummary extends StatelessWidget {
  final List<TransactionModel> transactions;

  const MonthlySummary({
    super.key,
    required this.transactions,
  });

  String _formatMoney(double value) {
    if (value == 0) return "0";
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thu nhập', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${_formatMoney(income)} đ', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Chi tiêu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${_formatMoney(expense)} đ', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Tổng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${_formatMoney(total)} đ', style: TextStyle(color: total < 0 ? Colors.red : Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}