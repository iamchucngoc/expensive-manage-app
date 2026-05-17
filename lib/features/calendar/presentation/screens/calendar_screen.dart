// lib/features/calendar/presentation/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import '../../../../services/firestore_service.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/grouped_transaction_list.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  // Lọc giao dịch theo tháng hiện tại
  List<TransactionModel> _getTransactionsByMonth(List<TransactionModel> allTransactions) {
    return allTransactions.where((t) {
      return t.date.year == _currentMonth.year && t.date.month == _currentMonth.month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Lịch"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: FirestoreService().getTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTransactions = snapshot.data!;
          final monthTransactions = _getTransactionsByMonth(allTransactions);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header chuyển tháng
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _goToPreviousMonth,
                      ),
                      Text(
                        "${_currentMonth.month.toString().padLeft(2, '0')}/${_currentMonth.year}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _goToNextMonth,
                      ),
                    ],
                  ),
                ),

                // Lịch
                CalendarWidget(
                  transactions: allTransactions, // Truyền tất cả để highlight ngày
                  currentMonth: _currentMonth,
                ),

                // Tóm tắt tháng (theo tháng hiện tại)
                MonthlySummary(transactions: monthTransactions),

                const SizedBox(height: 8),

                // Danh sách giao dịch của tháng
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Giao dịch tháng ${_currentMonth.month}/${_currentMonth.year}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(
                  height: 420,
                  child: GroupedTransactionList(
                    transactions: monthTransactions,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}