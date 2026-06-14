// lib/features/calendar/presentation/screens/calendar_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import '../../../transaction/data/services/transaction_service.dart';
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
  DateTime _selectedDate = DateTime.now();

  void _changeMonth(int step) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + step);
    });
  }

  void _pickDate() {
    DateTime tempDate = _currentMonth;
    final Color primaryColor = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                color: primaryColor, 
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Bỏ qua', style: TextStyle(color: Colors.white, fontSize: 16))),
                    GestureDetector(
                      onTap: () {
                        setState(() => _currentMonth = tempDate);
                        Navigator.pop(context);
                      },
                      child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.monthYear,
                  initialDateTime: _currentMonth,
                  onDateTimeChanged: (DateTime newDate) => tempDate = newDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<TransactionModel> _getTransactionsByMonth(List<TransactionModel> allTransactions) {
    return allTransactions.where((t) => t.date.year == _currentMonth.year && t.date.month == _currentMonth.month).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = Theme.of(context).primaryColor;
    final transactionService = Provider.of<TransactionService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<TransactionModel>>(
        stream: transactionService.getTransactions(FirebaseAuth.instance.currentUser?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final allTransactions = snapshot.data ?? [];
          final monthTransactions = _getTransactionsByMonth(allTransactions);

          return SingleChildScrollView(
            child: Column(
              children: [
                // HEADER CHỌN NGÀY ĐỒNG BỘ
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap: () => _changeMonth(-1), child: const Icon(Icons.chevron_left, size: 32, color: Colors.black54)),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                          decoration: BoxDecoration(color: primaryPink.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "${_currentMonth.month.toString().padLeft(2, '0')}/${_currentMonth.year}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryPink), // Đổi màu chữ theo Theme
                          ),
                        ),
                      ),
                      GestureDetector(onTap: () => _changeMonth(1), child: const Icon(Icons.chevron_right, size: 32, color: Colors.black54)),
                    ],
                  ),
                ),

                CalendarWidget(
                  transactions: monthTransactions,
                  currentMonth: _currentMonth,
                  onDateSelected: (date) => setState(() => _selectedDate = date),
                ),
                MonthlySummary(transactions: monthTransactions),
                GroupedTransactionList(transactions: monthTransactions),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}