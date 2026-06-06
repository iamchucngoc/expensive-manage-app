// lib/features/calendar/presentation/widgets/transaction_calendar_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart'; // THÊM ICONIFY
import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/data/services/transaction_service.dart';
import '../../../transaction/presentation/screens/add_transaction_screen.dart';

class TransactionCalendarItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCalendarItem({super.key, required this.transaction});

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
          // CHUYỂN SANG MÀN HÌNH NHẬP VỚI TRANSACTION ĐƯỢC CHỌN ĐỂ SỬA
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

            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
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
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Tên danh mục
              Expanded(
                child: Text(
                  transaction.categoryName, 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              
              // Số tiền
              Text(
                '${transaction.amount.toInt()} đ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              
              const SizedBox(width: 8),
              
            
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}