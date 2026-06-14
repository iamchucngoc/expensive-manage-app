// lib/features/budget/presentation/screens/budget_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../transaction/data/services/transaction_service.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../../../category/data/category_colors.dart';
import '../../data/models/budget_model.dart';
import '../../data/services/budget_service.dart';
import 'budget_setup_screen.dart';
import '../../../report/presentation/screens/category_detail_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});
  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime currentDate = DateTime.now();
  final BudgetService budgetService = BudgetService();

  void _changeMonth(int step) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + step);
    });
  }

  void _pickDate() {
    DateTime tempDate = currentDate;
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
                        setState(() => currentDate = tempDate);
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
                  initialDateTime: currentDate,
                  onDateTimeChanged: (DateTime newDate) => tempDate = newDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMoney(double value) {
    if (value == 0) return "0";
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final transactionService = Provider.of<TransactionService>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 28),
                const Text('Ngân sách', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => BudgetSetupScreen(initialMonth: currentDate.month, initialYear: currentDate.year),
                  )),
                  child: const Icon(Icons.tune, size: 28),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(onTap: () => _changeMonth(-1), child: const Icon(Icons.chevron_left, size: 32, color: Colors.black54)),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      "${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                ),
                GestureDetector(onTap: () => _changeMonth(1), child: const Icon(Icons.chevron_right, size: 32, color: Colors.black54)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<BudgetModel?>(
              stream: budgetService.getBudget(userId, currentDate.month, currentDate.year),
              builder: (context, budgetSnapshot) {
                return StreamBuilder<List<TransactionModel>>(
                  stream: transactionService.getTransactions(userId),
                  builder: (context, txSnapshot) {
                    if (txSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    final budget = budgetSnapshot.data;
                    final expenses = (txSnapshot.data ?? []).where((t) => t.type == TransactionType.expense && t.date.month == currentDate.month && t.date.year == currentDate.year).toList();
                    double totalSpent = expenses.fold(0, (sum, t) => sum + t.amount);
                    
                    Map<String, double> spentByCategory = {};
                    Map<String, String> iconByCategory = {};
                    Map<String, String> colorByCategory = {};
                    for (var t in expenses) {
                      spentByCategory[t.categoryName] = (spentByCategory[t.categoryName] ?? 0) + t.amount;
                      iconByCategory[t.categoryName] = t.categoryIcon;
                      colorByCategory[t.categoryName] = t.categoryColor;
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildBudgetBar(
                            title: "Tổng ngân sách", budgetAmount: budget?.totalBudget ?? 0, spentAmount: totalSpent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => CategoryDetailScreen(categoryName: "Tổng chi tiêu", amount: totalSpent, isExpense: true, isYearMode: false, currentDate: currentDate, transactions: expenses),
                            ))
                          ),
                          const SizedBox(height: 24),
                          Divider(color: Colors.grey.shade300, height: 1),
                          const SizedBox(height: 16),
                          ...(budget?.categoryBudgets.entries.where((e) => e.value > 0).map((e) {
                            String catName = e.key;
                            double catSpent = spentByCategory[catName] ?? 0;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _buildBudgetBar(
                                title: catName, budgetAmount: e.value, spentAmount: catSpent,
                                icon: iconByCategory[catName] ?? 'mdi:help', colorHex: colorByCategory[catName] ?? '#000000',
                                onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => CategoryDetailScreen(categoryName: catName, amount: catSpent, isExpense: true, isYearMode: false, currentDate: currentDate, transactions: expenses.where((t) => t.categoryName == catName).toList()),
                                ))
                              ),
                            );
                          }).toList() ?? []),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBar({required String title, required double budgetAmount, required double spentAmount, String? icon, String? colorHex, VoidCallback? onTap}) {
    double remaining = budgetAmount - spentAmount;
    double percent = budgetAmount > 0 ? (spentAmount / budgetAmount) : 0;
    bool isOver = remaining < 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              if (icon != null) ...[Iconify(icon, color: hexToColor(colorHex!), size: 24), const SizedBox(width: 8)],
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text("Còn lại", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text('${isOver ? "" : ""}${_formatMoney(remaining)} đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isOver ? Colors.red : Colors.black)),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: percent > 1 ? 1.0 : percent, minHeight: 10, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(isOver ? Colors.red : Colors.orange)),
                ),
              ),
              const SizedBox(width: 8),
              Text('${(percent * 100).toStringAsFixed(0)} %', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngân sách ${_formatMoney(budgetAmount)} đ', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              Text('Chi tiêu ${_formatMoney(spentAmount)} đ', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}