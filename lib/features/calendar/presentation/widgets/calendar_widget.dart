// lib/features/calendar/presentation/widgets/calendar_widget.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';

class CalendarWidget extends StatelessWidget {
  final List<TransactionModel> transactions;
  final DateTime currentMonth;

  const CalendarWidget({
    super.key,
    required this.transactions,
    required this.currentMonth,
  });

  double _getIncome(DateTime day) {
    return transactions
        .where((t) => _isSameDay(t.date, day) && t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _getExpense(DateTime day) {
    return transactions
        .where((t) => _isSameDay(t.date, day) && t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday; // 1 = T2

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header tháng
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "${currentMonth.month.toString().padLeft(2, '0')}/${currentMonth.year}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Ngày trong tuần
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                  .map((e) => Expanded(
                        child: Center(
                          child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Grid lịch - Full month
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.95,        // Điều chỉnh để vuông hơn
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayNumber = index - firstWeekday + 2;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
              final income = _getIncome(date);
              final expense = _getExpense(date);

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNumber',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    if (income > 0 || expense > 0) ...[
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (income > 0)
                            Text('+${income.toInt()}', style: const TextStyle(fontSize: 10, color: Colors.blue)),
                          if (expense > 0)
                            Text(' -${expense.toInt()}', style: const TextStyle(fontSize: 10, color: Colors.red)),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}