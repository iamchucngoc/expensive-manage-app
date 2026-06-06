// lib/features/calendar/presentation/screens/calendar_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
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

  List<TransactionModel> _getTransactionsByMonth(List<TransactionModel> allTransactions) {
    return allTransactions.where((t) {
      return t.date.year == _currentMonth.year && t.date.month == _currentMonth.month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactionService = Provider.of<TransactionService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<List<TransactionModel>>(
          stream: transactionService.getTransactions(
            FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
            }

            final allTransactions = snapshot.data ?? [];
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

                  // Lịch nguyên khối
                  CalendarWidget(
                    transactions: monthTransactions,
                    currentMonth: _currentMonth,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),

          
                  MonthlySummary(transactions: monthTransactions),

              
                  GroupedTransactionList(
                    transactions: monthTransactions,
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}