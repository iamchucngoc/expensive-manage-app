// lib/features/transaction/presentation/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../category/data/models/category_model.dart';
import '../../../category/data/services/category_service.dart';
import '../../data/models/transaction_model.dart';
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

  bool isExpense = true;
  String amount = '0';
  DateTime selectedDate = DateTime.now();
  String selectedCategory = '';
  final TextEditingController noteController = TextEditingController();

  final Color primaryPink = const Color(0xFFFF6492);

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

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

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
      builder: (context) {
        return AmountKeyboard(onTap: onKeyboardTap);
      },
    );
  }

  void _pickDate() {
    DateTime tempDate = selectedDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // Thanh header chứa Bỏ qua và OK nền hồng
              Container(
                color: primaryPink,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Bỏ qua',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedDate = tempDate);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // Vòng cuộn chọn ngày tháng năm kiểu iOS
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(Icons.check, size: 40, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text(
                widget.editingTransaction != null ? 'Đã cập nhật dữ liệu' : 'Đã nhập dữ liệu',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> saveTransaction(List<CategoryModel> categories) async {
    if (amount == '0') {
      final shouldContinue = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text(
            'Số tiền vẫn là 0 bạn có muốn tiếp tục ?',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Tiếp tục', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.pop(context, true),
            ),
            CupertinoDialogAction(
              child: const Text('Bỏ qua', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      );

      if (shouldContinue != true) return;
    }

    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng chọn danh mục'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lỗi: Chưa đăng nhập!'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final selectedCategoryModel =
          categories.firstWhere((e) => e.name == selectedCategory);
      final transactionId = widget.editingTransaction?.id ?? const Uuid().v4();
      final transaction = TransactionModel(
        id: transactionId,
        userId: user.uid,
        amount: double.tryParse(amount) ?? 0,
        type: isExpense ? TransactionType.expense : TransactionType.income,
        categoryId: selectedCategoryModel.id,
        categoryName: selectedCategoryModel.name,
        categoryIcon: selectedCategoryModel.icon,
        note: noteController.text,
        date: selectedDate,
      );

      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';

    final isEditing = widget.editingTransaction != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEditing)
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),

                const SizedBox(height: 10),
                TransactionTypeToggle(
                  isExpense: isExpense,
                  onChanged: (value) {
                    setState(() {
                      isExpense = value;
                      selectedCategory = '';
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Hàng: Ngày (Đã cấu hình các nút bấm tiến lùi hoạt động thực tế)
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300))),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 80,
                          child: Text('Ngày',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      GestureDetector(
                          onTap: _previousDay, // Bấm mũi tên trái lùi 1 ngày
                          child: const Icon(Icons.chevron_left,
                              color: Colors.black54)),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDate, // Bấm vào dải ngày mở bảng cuộn 3D
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: primaryPink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(formattedDate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: _nextDay, // Bấm mũi tên phải tiến 1 ngày
                          child: const Icon(Icons.chevron_right,
                              color: Colors.black54)),
                    ],
                  ),
                ),

                // Hàng: Ghi chú
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300))),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 80,
                          child: Text('Ghi chú',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: TextField(
                          controller: noteController,
                          decoration: const InputDecoration(
                            hintText: 'Chưa nhập vào',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Hàng: Tiền chi / Tiền thu
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300))),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: openKeyboard,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 80,
                            child: Text(isExpense ? 'Tiền chi' : 'Tiền thu',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: primaryPink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              amount,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('đ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lưới Danh mục
                StreamBuilder<List<CategoryModel>>(
                  stream: categoryService.getCategories(
                    FirebaseAuth.instance.currentUser?.uid ?? '',
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final categories = snapshot.data!
                        .where(
                            (e) => e.type == (isExpense ? "expense" : "income"))
                        .toList();

                    if (categories.isEmpty) {
                      return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Chưa có danh mục"));
                    }

                    if (selectedCategory.isEmpty && categories.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(
                              () => selectedCategory = categories.first.name);
                        }
                      });
                    }

                    return CategoryGrid(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onSelect: (value) =>
                          setState(() => selectedCategory = value),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Nút Lưu/Sửa dưới cùng
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      categoryService
                          .getCategories(
                            FirebaseAuth.instance.currentUser?.uid ?? '',
                          )
                          .first
                          .then((allCats) {
                        final filteredCats = allCats
                            .where((e) =>
                                e.type == (isExpense ? "expense" : "income"))
                            .toList();
                        saveTransaction(filteredCats);
                      });
                    },
                    child: Text(
                      isEditing
                          ? (isExpense ? 'Chỉnh sửa khoản chi' : 'Chỉnh sửa khoản thu')
                          : (isExpense ? 'Nhập khoản chi' : 'Nhập khoản thu'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}