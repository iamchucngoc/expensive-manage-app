// lib/features/report/presentation/widgets/category_transaction_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/data/services/transaction_service.dart';
import '../../../transaction/presentation/screens/add_transaction_screen.dart';
import '../../../category/data/category_colors.dart';

class CategoryTransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const CategoryTransactionList({super.key, required this.transactions});

  // Hàm gom nhóm giao dịch theo ngày
  Map<String, List<TransactionModel>> _groupTransactionsByDate(List<TransactionModel> txs) {
    Map<String, List<TransactionModel>> grouped = {};
    for (var t in txs) {
      String dateStr = '${t.date.day.toString().padLeft(2, '0')}/${t.date.month.toString().padLeft(2, '0')}/${t.date.year}';
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(t);
    }
    return grouped;
  }

  String _formatMoney(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const SizedBox();

    final groupedTransactions = _groupTransactionsByDate(transactions);
    final sortedDates = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a)); // Sắp xếp ngày mới nhất lên trên

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        String dateStr = sortedDates[index];
        List<TransactionModel> dailyTransactions = groupedTransactions[dateStr]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFD0C3E1), 
              child: Text(
                dateStr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            
           
            ...dailyTransactions.map((t) => _buildTransactionItem(context, t)),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel t) {
    return Slidable(
      key: ValueKey(t.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => TransactionService().deleteTransaction(t.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xóa',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Bấm vào để sửa giao dịch
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(editingTransaction: t),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Đồng bộ Iconify và categoryColor
              Iconify(
                t.categoryIcon,
                color: hexToColor(t.categoryColor),
                size: 28,
              ),
              const SizedBox(width: 16),
              
              // Tên danh mục
              Expanded(
                child: Text(
                  t.categoryName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Số tiền
              Text(
                '${_formatMoney(t.amount)} đ',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}