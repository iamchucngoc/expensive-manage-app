// lib/features/report/presentation/screens/report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../transaction/data/services/transaction_service.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../widgets/expense_chart.dart';
import '../widgets/category_report_item.dart';
import 'category_detail_screen.dart';
import '../../data/services/ai_advisor_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isYearMode = false;
  bool isExpense = true;
  DateTime currentDate = DateTime.now();

  void _changeDate(int step) {
    setState(() {
      currentDate = isYearMode 
        ? DateTime(currentDate.year + step, 1) 
        : DateTime(currentDate.year, currentDate.month + step);
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModeButton("Hàng tháng", !isYearMode, () => setState(() => isYearMode = false), primaryColor), 
              _buildModeButton("Hàng năm", isYearMode, () => setState(() => isYearMode = true), primaryColor), 
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: () => _changeDate(-1), child: const Icon(Icons.chevron_left, size: 32, color: Colors.black54)),
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
                    isYearMode ? "${currentDate.year}" : "${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ),
              GestureDetector(onTap: () => _changeDate(1), child: const Icon(Icons.chevron_right, size: 32, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),

          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: transactionService.getTransactions(userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final all = snapshot.data!.where((t) {
                  if (isYearMode) return t.date.year == currentDate.year;
                  return t.date.year == currentDate.year && t.date.month == currentDate.month;
                }).toList();

                final expenseTotal = all.where((t) => t.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount);
                final incomeTotal = all.where((t) => t.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount);
                final balance = incomeTotal - expenseTotal;
                final currentList = all.where((t) => t.type == (isExpense ? TransactionType.expense : TransactionType.income)).toList();
                
                final categoryMap = <String, Map<String, dynamic>>{};
                for (var t in currentList) {
                  if (!categoryMap.containsKey(t.categoryName)) {
                    categoryMap[t.categoryName] = {'amount': 0.0, 'icon': t.categoryIcon, 'color': t.categoryColor};
                  }
                  categoryMap[t.categoryName]!['amount'] += t.amount;
                }
                var sortedCategories = categoryMap.entries.toList()..sort((a, b) => b.value['amount'].compareTo(a.value['amount']));

                return SingleChildScrollView(
                  child: Column(
                    children: [

                      _buildSummaryTable(expenseTotal, incomeTotal, balance),
                      const SizedBox(height: 12),
                    
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade50, 
                              foregroundColor: Colors.purple, 
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.purple.shade200, width: 1),
                              ),
                            ),
                            icon: const Icon(Icons.auto_awesome, size: 20), 
                            label: const Text('Nhận lời khuyên từ AI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.purple)),
                              );

                              final aiService = AiAdvisorService();
                              final advice = await aiService.getAdvice(
                                income: incomeTotal,
                                expense: expenseTotal,
                                sortedCategories: sortedCategories,
                              );

                              if (context.mounted) {
                                Navigator.pop(context); 
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: Row(
                                      children: const [
                                        Icon(Icons.auto_awesome, color: Colors.purple),
                                        SizedBox(width: 8),
                                        Text('AI Cố vấn 🌸', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 18)),
                                      ],
                                    ),
                                    content: Text(advice, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Đã hiểu 💖', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 15)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildChartToggle("Chi tiêu", isExpense, () => setState(() => isExpense = true), primaryColor)), 
                          Expanded(child: _buildChartToggle("Thu nhập", !isExpense, () => setState(() => isExpense = false), primaryColor)), 
                        ],
                      ),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 16),
                      ExpensePieChart(data: sortedCategories, isExpense: isExpense),
                      const SizedBox(height: 16),
                      ...sortedCategories.map((entry) {
                        final total = isExpense ? expenseTotal : incomeTotal;
                        final percent = total > 0 ? (entry.value['amount'] / total * 100) : 0.0;
                        return CategoryReportItem(
                          categoryName: entry.key, icon: entry.value['icon'], colorHex: entry.value['color'],
                          amount: entry.value['amount'], percent: percent,
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => CategoryDetailScreen(
                              categoryName: entry.key, amount: entry.value['amount'],
                              isExpense: isExpense, isYearMode: isYearMode, currentDate: currentDate,
                              transactions: currentList.where((t) => t.categoryName == entry.key).toList(),
                            ),
                          )),
                        );
                      }),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, bool selected, VoidCallback onTap, Color themeColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(color: selected ? themeColor : Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(text, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildChartToggle(String text, bool selected, VoidCallback onTap, Color themeColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: selected ? themeColor : Colors.transparent, width: 2))),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: selected ? themeColor : Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // BẢNG TỔNG KẾT NẰM NGANG - SỐ TO - CÓ DẤU PHẨY
  Widget _buildSummaryTable(double expense, double income, double balance) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: [
          _summaryColumn("Chi tiêu", expense, Colors.red, isNegative: true),
          Container(width: 1, height: 40, color: Colors.grey.shade200), 
          _summaryColumn("Thu nhập", income, Colors.blue),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _summaryColumn("Thu chi", balance, balance >= 0 ? Colors.blue : Colors.red, isBalance: true),
        ],
      ),
    );
  }

  Widget _summaryColumn(String title, double amount, Color color, {bool isNegative = false, bool isBalance = false}) {
    String prefix = "";
    if (isBalance && amount > 0) prefix = "+";
    if (isNegative && amount > 0) prefix = "-";

    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "$prefix${_formatMoney(amount)}",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16), 
          ),
        ),
      ],
    );
  }
}