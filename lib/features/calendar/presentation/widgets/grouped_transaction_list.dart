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

  @override
  Widget build(BuildContext context) {
    // 1. Xếp ngày tăng dần để hiển thị từ đầu tháng đến cuối tháng
    final sortedTransactions = List<TransactionModel>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    // 2. Gom nhóm giao dịch theo từng ngày
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

    // 3. Render danh sách
    return ListView.builder(
      shrinkWrap: true, // Bắt buộc để cuộn mượt bên trong SingleChildScrollView
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
            // Header ngày (Dải màu tím nhạt)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFCDB4DB), // Nền tím đồng bộ với lịch
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateKey, style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(
                    '${dailyTotal.toInt()} đ',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // Các giao dịch trong ngày
            ...dayTransactions.map((t) => TransactionCalendarItem(transaction: t)).toList(),
          ],
        );
      },
    );
  }
}