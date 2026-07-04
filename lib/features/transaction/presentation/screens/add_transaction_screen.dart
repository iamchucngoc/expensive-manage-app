// lib/features/transaction/presentation/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../category/data/models/category_model.dart';
import '../../../category/data/services/category_service.dart';
import '../../../budget/data/services/budget_service.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/receipt_ocr_service.dart';
import '../../data/services/transaction_service.dart';

import '../widgets/amount_keyboard.dart';
import '../widgets/category_grid.dart';
import '../widgets/transaction_type_toggle.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? editingTransaction;
  const AddTransactionScreen({super.key, this.editingTransaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final CategoryService categoryService = CategoryService();
  final ReceiptOcrService _receiptOcrService = ReceiptOcrService();
  final ImagePicker _imagePicker = ImagePicker();

  bool isExpense = true;
  String amount = '0';
  DateTime selectedDate = DateTime.now();
  String selectedCategory = '';
  final TextEditingController noteController = TextEditingController();
  bool _isScanning = false;
  ReceiptOcrResult? _lastResult;

  @override
  void initState() {
    super.initState();
    if (widget.editingTransaction != null) {
      final t = widget.editingTransaction!;
      amount = t.amount.toString();
      if (amount.endsWith('.0')) {
        amount = amount.substring(0, amount.length - 2);
      }
      selectedDate = t.date;
      selectedCategory = t.categoryName;
      noteController.text = t.note ?? '';
      isExpense = t.type == TransactionType.expense;
    }
  }

  void _previousDay() { setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1))); }
  void _nextDay() { setState(() => selectedDate = selectedDate.add(const Duration(days: 1))); }

  void onKeyboardTap(String value) {
    setState(() {
      if (value == 'C') {
        amount = '0';
      } else if (value == '⌫') {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = '0';
        }
      } else {
        if (amount == '0') {
          amount = value;
        } else {
          if (amount.length < 12) {
            amount += value;
          }
        }
      }
    });
  }

  void openKeyboard() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AmountKeyboard(onTap: onKeyboardTap),
    );
  }

  void _pickDate() {
    DateTime tempDate = selectedDate;
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
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Bỏ qua', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedDate = tempDate);
                        Navigator.pop(context);
                      },
                      child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) => tempDate = newDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMoneyStr(String value) {
    if (value.isEmpty || value == '0') return '0';
    return value.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  Future<void> _pickReceiptSource() async {
    if (_isScanning) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Chụp ảnh ngay'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Chọn ảnh từ thư viện'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;
    await _processReceiptImage(source);
  }

  Future<void> _processReceiptImage(ImageSource source) async {
    setState(() => _isScanning = true);

    try {
      final XFile? image = await _imagePicker.pickImage(source: source, imageQuality: 90);
      if (image == null) {
        if (!mounted) return;
        setState(() => _isScanning = false);
        return;
      }

      final bytes = await image.readAsBytes();
      final result = await _receiptOcrService.extractFromBytes(bytes);
      if (!mounted) return;

      final categories = await categoryService.getCategories(FirebaseAuth.instance.currentUser?.uid ?? '').first;
      final mergedText = [result.merchant, result.note, result.categorySuggestion]
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .join(' ');
      final suggestedCategory = _receiptOcrService.suggestCategory(mergedText, categories);
      final suggestedNote = _receiptOcrService.suggestNote(result.note);

      setState(() {
        _isScanning = false;
        _lastResult = result;
        if (result.amount != null) {
          amount = result.amount!.toStringAsFixed(0);
        }
        if (result.date != null) {
          selectedDate = result.date!;
        }
        if (suggestedCategory != null && suggestedCategory.isNotEmpty) {
          selectedCategory = suggestedCategory;
        }
        if (suggestedNote != null) {
          noteController.text = suggestedNote;
        } else {
          noteController.text = '';
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đọc hóa đơn. Vui lòng kiểm tra lại trước khi lưu.'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đọc hóa đơn: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog() {
    final Color primaryColor = Theme.of(context).primaryColor;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 2)),
                child: Icon(Icons.check, size: 40, color: primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                widget.editingTransaction != null ? 'Đã cập nhật dữ liệu' : 'Đã nhập dữ liệu',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<bool> _checkBudgetBeforeSave(CategoryModel selectedCategoryModel, double newAmount) async {
    if (!isExpense || newAmount <= 0) {
      return true;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return true;
    }

    final budget = await BudgetService().getBudget(user.uid, selectedDate.month, selectedDate.year).first;
    if (budget == null) {
      return true;
    }

    final categoryBudget = budget.categoryBudgets[selectedCategoryModel.name] ?? 0.0;
    if (categoryBudget <= 0) {
      return true;
    }

    final transactionService = Provider.of<TransactionService>(context, listen: false);
    final transactions = await transactionService.getTransactions(user.uid).first;
    double currentMonthlySpend = transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.categoryName == selectedCategoryModel.name &&
            t.date.year == selectedDate.year &&
            t.date.month == selectedDate.month)
        .fold(0.0, (sum, t) => sum + t.amount);

    if (widget.editingTransaction != null) {
      final editingTransaction = widget.editingTransaction!;
      final isSameCategoryAndMonth = editingTransaction.categoryName == selectedCategoryModel.name &&
          editingTransaction.date.year == selectedDate.year &&
          editingTransaction.date.month == selectedDate.month;
      if (isSameCategoryAndMonth) {
        currentMonthlySpend -= editingTransaction.amount;
      }
    }

    if (!BudgetService.shouldWarnBudgetExceeded(
      newAmount: newAmount,
      categoryBudget: categoryBudget,
      currentMonthlySpend: currentMonthlySpend,
    )) {
      return true;
    }

    final shouldContinue = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cảnh báo vượt ngân sách', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(
          'Thêm khoản chi này sẽ vượt ngân sách cho danh mục "${selectedCategoryModel.name}" trong tháng ${selectedDate.month}/${selectedDate.year}.\n\nBạn có muốn tiếp tục không?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          CupertinoDialogAction(child: const Text('Hủy', style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(context, false)),
          CupertinoDialogAction(child: const Text('Tiếp tục', style: TextStyle(color: Colors.blue)), onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    return shouldContinue == true;
  }

  Future<void> saveTransaction(List<CategoryModel> categories) async {
    if (amount == '0') {
      final shouldContinue = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Số tiền vẫn là 0 bạn có muốn tiếp tục ?', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
          actions: [
            CupertinoDialogAction(child: const Text('Tiếp tục', style: TextStyle(color: Colors.blue)), onPressed: () => Navigator.pop(context, true)),
            CupertinoDialogAction(child: const Text('Bỏ qua', style: TextStyle(color: Colors.blue)), onPressed: () => Navigator.pop(context, false)),
          ],
        ),
      );
      if (shouldContinue != true) return;
    }

    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn danh mục'), backgroundColor: Colors.orange));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi: Chưa đăng nhập!'), backgroundColor: Colors.red));
      return;
    }

    try {
      final selectedCategoryModel = categories.firstWhere((e) => e.name == selectedCategory);
      final newAmount = double.tryParse(amount) ?? 0;
      final shouldProceed = await _checkBudgetBeforeSave(selectedCategoryModel, newAmount);
      if (!shouldProceed) {
        return;
      }

      final transactionId = widget.editingTransaction?.id ?? const Uuid().v4();
      final transaction = TransactionModel(
        id: transactionId,
        userId: user.uid,
        amount: double.tryParse(amount) ?? 0,
        type: isExpense ? TransactionType.expense : TransactionType.income,
        categoryId: selectedCategoryModel.id,
        categoryName: selectedCategoryModel.name,
        categoryIcon: selectedCategoryModel.icon,
        categoryColor: selectedCategoryModel.colorHex, 
        note: noteController.text,
        date: selectedDate,
      );

      final transactionService = Provider.of<TransactionService>(context, listen: false);
      if (widget.editingTransaction != null) {
        await transactionService.updateTransaction(transaction);
      } else {
        await transactionService.addTransaction(transaction);
      }

      if (!mounted) return;
      _showSuccessDialog();

      if (widget.editingTransaction != null) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        setState(() {
          amount = '0';
          selectedCategory = '';
          isExpense = true;
          selectedDate = DateTime.now();
          noteController.clear();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final formattedDate = '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
    final isEditing = widget.editingTransaction != null;

    Widget content = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEditing)
              IconButton(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),

            const SizedBox(height: 10),
            TransactionTypeToggle(
              isExpense: isExpense,
              onChanged: (value) => setState(() {
                isExpense = value;
                selectedCategory = '';
              }),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text('Ngày', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(onTap: _previousDay, child: const Icon(Icons.chevron_left, size: 28, color: Colors.black54)),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15), 
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                formattedDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor), 
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(onTap: _nextDay, child: const Icon(Icons.chevron_right, size: 28, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const SizedBox(width: 80, child: Text('Ghi chú', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87))),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(hintText: 'Chưa nhập vào', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: openKeyboard,
                child: Row(
                  children: [
                    SizedBox(width: 80, child: Text(isExpense ? 'Tiền chi' : 'Tiền thu', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87))),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(_formatMoneyStr(amount), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('đ', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _isScanning ? null : _pickReceiptSource,
                      icon: _isScanning
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 24),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_lastResult != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Đã đọc hóa đơn', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 6),
                    if (_lastResult!.merchant != null && _lastResult!.merchant!.isNotEmpty)
                      Text('Cửa hàng: ${_lastResult!.merchant}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    if (_lastResult!.amount != null)
                      Text('Số tiền: ${_lastResult!.amount!.toStringAsFixed(0)} đ', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),

            const Text('Danh mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),

            StreamBuilder<List<CategoryModel>>(
              stream: categoryService.getCategories(FirebaseAuth.instance.currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final categories = snapshot.data!.where((e) => e.type == (isExpense ? "expense" : "income")).toList();
                if (categories.isEmpty) return const Padding(padding: EdgeInsets.all(20), child: Text("Chưa có danh mục", style: TextStyle(color: Colors.black87)));

                if (selectedCategory.isEmpty && categories.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => selectedCategory = categories.first.name);
                  });
                }

                return CategoryGrid(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onSelect: (value) => setState(() => selectedCategory = value),
                );
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                onPressed: () {
                  categoryService.getCategories(FirebaseAuth.instance.currentUser?.uid ?? '').first.then((allCats) {
                    final filteredCats = allCats.where((e) => e.type == (isExpense ? "expense" : "income")).toList();
                    saveTransaction(filteredCats);
                  });
                },
                child: Text(
                  isEditing ? (isExpense ? 'Chỉnh sửa khoản chi' : 'Chỉnh sửa khoản thu') : (isExpense ? 'Nhập khoản chi' : 'Nhập khoản thu'),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: isEditing ? SafeArea(child: content) : content,
    );
  }
}