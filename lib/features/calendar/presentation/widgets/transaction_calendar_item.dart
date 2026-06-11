// lib/features/calendar/presentation/widgets/transaction_calendar_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart'; 
import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/data/services/transaction_service.dart';
import '../../../transaction/presentation/screens/add_transaction_screen.dart';
import '../../../category/data/category_colors.dart'; 

class TransactionCalendarItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCalendarItem({super.key, required this.transaction});

  String _formatMoney(double value) {
    if (value == 0) return "0";
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.blue : Colors.black;

    return Slidable(
      key: ValueKey(transaction.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25, 
        children: [
          SlidableAction(
            onPressed: (context) => TransactionService().deleteTransaction(transaction.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xóa',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(editingTransaction: transaction),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8), 
                ),
                child: Center(
                  child: Iconify(
                    transaction.categoryIcon, 
                    color: hexToColor(transaction.categoryColor), 
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Text(
                  transaction.categoryName, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              
              Text(
                '${_formatMoney(transaction.amount)} đ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: amountColor),
              ),
              
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}