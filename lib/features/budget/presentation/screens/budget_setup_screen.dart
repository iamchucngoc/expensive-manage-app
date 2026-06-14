// lib/features/budget/presentation/screens/budget_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../category/data/models/category_model.dart';
import '../../../category/data/services/category_service.dart';
import '../../../category/data/category_colors.dart';
import '../../data/models/budget_model.dart';
import '../../data/services/budget_service.dart';

class BudgetSetupScreen extends StatefulWidget {
  final int initialMonth;
  final int initialYear;
  const BudgetSetupScreen({super.key, required this.initialMonth, required this.initialYear});
  @override
  State<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  late int selectedMonth;
  late int selectedYear;
  double totalBudget = 0;
  Map<String, double> categoryBudgets = {};
  bool _isTotalManuallySet = false; 

  final BudgetService budgetService = BudgetService();


  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
    _loadBudget();
  }

  void _loadBudget() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    budgetService.getBudget(userId, selectedMonth, selectedYear).first.then((budget) {
      if (budget != null) {
        setState(() {
          totalBudget = budget.totalBudget;
          categoryBudgets = Map.from(budget.categoryBudgets);
          double sumCats = categoryBudgets.values.fold(0.0, (a, b) => a + b);
          _isTotalManuallySet = (totalBudget > 0 && totalBudget != sumCats);
        });
      } else {
        setState(() {
          totalBudget = 0;
          categoryBudgets = {};
          _isTotalManuallySet = false;
        });
      }
    });
  }

  void _changeMonth(int step) {
    setState(() {
      DateTime newDate = DateTime(selectedYear, selectedMonth + step);
      selectedMonth = newDate.month;
      selectedYear = newDate.year;
    });
    _loadBudget();
  }

  // HÀM CHỌN NGÀY ĐỒNG BỘ
  void _pickDate() {
    DateTime tempDate = DateTime(selectedYear, selectedMonth);
    
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
                        setState(() {
                          selectedMonth = tempDate.month;
                          selectedYear = tempDate.year;
                        });
                        _loadBudget();
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
                  initialDateTime: tempDate,
                  onDateTimeChanged: (DateTime newDate) => tempDate = newDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final budget = BudgetModel(
      id: '${userId}_${selectedYear}_$selectedMonth', userId: userId, month: selectedMonth, year: selectedYear,
      totalBudget: totalBudget, categoryBudgets: categoryBudgets,
    );
    await budgetService.saveBudget(budget);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _showAmountInputDialog(String title, double currentValue, Function(double) onSave) async {
    TextEditingController ctrl = TextEditingController(text: currentValue > 0 ? currentValue.toInt().toString() : '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Nhập số tiền', suffixText: 'đ'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              double val = double.tryParse(ctrl.text) ?? 0;
              onSave(val);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  String _formatMoney(double value) {
    if (value == 0) return 'chưa đặt';
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    double sumCategoryBudgets = categoryBudgets.values.fold(0.0, (prev, amount) => prev + amount);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, size: 28)),
                  const Text('Cài đặt ngân sách', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(onTap: _save, child: const Text('Lưu', style: TextStyle(fontSize: 16, color: Colors.blue))),
                ],
              ),
            ),

            // HEADER CHỌN NGÀY ĐỒNG BỘ
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: () => _changeMonth(-1), child: const Icon(Icons.chevron_left, size: 32, color: Colors.black54)),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                      decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "${selectedMonth.toString().padLeft(2, '0')}/$selectedYear",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(onTap: () => _changeMonth(1), child: const Icon(Icons.chevron_right, size: 32, color: Colors.black54)),
                ],
              ),
            ),

            GestureDetector(
              onTap: () => _showAmountInputDialog("Tổng ngân sách", totalBudget, (val) {
                setState(() {
                  totalBudget = val;
                  _isTotalManuallySet = true; 
                });
              }),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng ngân sách', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(_formatMoney(totalBudget), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Tổng ngân sách theo hạng mục: ${_formatMoney(sumCategoryBudgets)}', style: const TextStyle(color: Colors.grey)),
              ),
            ),

            Expanded(
              child: StreamBuilder<List<CategoryModel>>(
                stream: CategoryService().getCategories(userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final expenseCats = snapshot.data!.where((c) => c.type == 'expense').toList();

                  return ListView.separated(
                    itemCount: expenseCats.length,
                    separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final cat = expenseCats[index];
                      final catBudget = categoryBudgets[cat.name] ?? 0;

                      return ListTile(
                        onTap: () => _showAmountInputDialog("Ngân sách: ${cat.name}", catBudget, (val) {
                          setState(() {
                            categoryBudgets[cat.name] = val;
                            if (!_isTotalManuallySet) {
                              totalBudget = categoryBudgets.values.fold(0.0, (a, b) => a + b);
                            }
                          });
                        }),
                        leading: Iconify(cat.icon, color: hexToColor(cat.colorHex), size: 28),
                        title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text(
                          _formatMoney(catBudget),
                          style: TextStyle(color: catBudget > 0 ? Colors.black : Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}