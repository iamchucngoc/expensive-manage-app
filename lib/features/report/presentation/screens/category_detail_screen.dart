// lib/features/report/presentation/screens/category_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../widgets/category_bar_chart.dart';
import '../../../calendar/presentation/widgets/grouped_transaction_list.dart'; 

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final double amount;
  final bool isExpense;
  final bool isYearMode;
  final DateTime currentDate;
  final List<TransactionModel> transactions;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.amount,
    required this.isExpense,
    required this.isYearMode,
    required this.currentDate,
    required this.transactions,
  });

  String _formatMoney(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, double> groupedData = {};
    for (var t in transactions) {
      int key = isYearMode ? t.date.month : t.date.day;
      groupedData[key] = (groupedData[key] ?? 0) + t.amount;
    }

    String timeLabel = isYearMode ? "Năm ${currentDate.year}" : "T${currentDate.month}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'NoraNote',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      "$categoryName ($timeLabel) ${_formatMoney(amount)} đ",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 24), 
                ],
              ),
            ),
            const SizedBox(height: 20),

            // BIỂU ĐỒ CỘT
            CategoryBarChart(
              groupedData: groupedData, 
              isYearMode: isYearMode, 
              currentDate: currentDate,
              color: isExpense ? Colors.orange : Colors.blue, 
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GroupedTransactionList(transactions: transactions), 
            ),
          ],
        ),
      ),
    );
  }
}