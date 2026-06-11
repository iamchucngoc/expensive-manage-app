// lib/features/calendar/presentation/widgets/grouped_transaction_list.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';
import 'transaction_calendar_item.dart';

class GroupedTransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const GroupedTransactionList({
    super.key,
    required this.transactions,
  });

  String _formatMoney(double value) {
    if (value == 0) return "0";
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = List<TransactionModel>.from(transactions)..sort((a, b) => a.date.compareTo(b.date));

    Map<String, List<TransactionModel>> grouped = {};
    for (var t in sortedTransactions) {
      String dateKey = "${t.date.day}/${t.date.month}/${t.date.year}";
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(t);
    }

    if (grouped.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text("Không có giao dịch trong tháng này")),
      );
    }

    return ListView.builder(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      padding: EdgeInsets.zero,
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        String dateKey = grouped.keys.elementAt(index);
        List<TransactionModel> dayTransactions = grouped[dateKey]!;

        double dailyTotal = dayTransactions.fold(0, (sum, item) {
          return item.type == TransactionType.income ? sum + item.amount : sum - item.amount;
        });

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFCDB4DB), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateKey, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    '${_formatMoney(dailyTotal)} đ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
            ...dayTransactions.map((t) => TransactionCalendarItem(transaction: t)).toList(),
          ],
        );
      },
    );
  }
}