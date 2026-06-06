// lib/features/calendar/presentation/widgets/calendar_widget.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';

class CalendarWidget extends StatelessWidget {
  final List<TransactionModel> transactions;
  final DateTime currentMonth;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.transactions,
    required this.currentMonth,
    required this.onDateSelected,
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
    // Logic tính ngày của tháng hiện tại và các ngày thừa của tháng trước/sau
    final daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = T2, 7 = CN

    final prevMonthDaysToShow = firstWeekday - 1;
    final prevMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    final daysInPrevMonth = DateUtils.getDaysInMonth(prevMonth.year, prevMonth.month);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1), // Viền khối lịch
      ),
      child: Column(
        children: [
          // Header: T2 -> CN
          Container(
            color: const Color(0xFFCDB4DB), // Nền tím nhạt theo UI
            child: Row(
              children: ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                  .map((e) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            e,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Lưới lịch 0 khoảng cách
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.85, // Kéo dài ô để chứa chữ
              mainAxisSpacing: 0, // Xóa khe hở
              crossAxisSpacing: 0, // Xóa khe hở
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              DateTime date;
              bool isCurrentMonth = true;

              if (index < prevMonthDaysToShow) {
                // Ngày của tháng trước
                isCurrentMonth = false;
                date = DateTime(prevMonth.year, prevMonth.month,
                    daysInPrevMonth - prevMonthDaysToShow + index + 1);
              } else if (index >= prevMonthDaysToShow + daysInMonth) {
                // Ngày của tháng sau
                isCurrentMonth = false;
                date = DateTime(currentMonth.year, currentMonth.month + 1,
                    index - (prevMonthDaysToShow + daysInMonth) + 1);
              } else {
                // Ngày trong tháng
                date = DateTime(currentMonth.year, currentMonth.month,
                    index - prevMonthDaysToShow + 1);
              }

              final income = _getIncome(date);
              final expense = _getExpense(date);

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrentMonth ? Colors.white : const Color(0xFFFDE8EB), // Hồng nhạt cho ngày ngoài tháng
                    border: Border.all(color: Colors.grey.shade300, width: 0.5), // Viền mảnh từng ô
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Đưa số ngày sang trái
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isCurrentMonth ? Colors.black : Colors.black54,
                          fontWeight: isCurrentMonth ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (income > 0)
                        Align(
                          alignment: Alignment.center,
                          child: Text('${income.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.blue)),
                        ),
                      if (expense > 0)
                        Align(
                          alignment: Alignment.center,
                          child: Text('${expense.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.red)),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}