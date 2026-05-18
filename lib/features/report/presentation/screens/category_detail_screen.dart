// lib/features/report/presentation/screens/category_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../widgets/category_bar_chart.dart';
import '../widgets/category_transaction_list.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final List<TransactionModel> transactions;
  final bool isExpense;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.transactions,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    final total = transactions.fold(0.0, (sum, t) => sum + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text("$categoryName (${transactions.length})"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          CategoryBarChart(transactions: transactions),
          const Divider(),
          Expanded(
            child: CategoryTransactionList(transactions: transactions),
          ),
        ],
      ),
    );
  }
}