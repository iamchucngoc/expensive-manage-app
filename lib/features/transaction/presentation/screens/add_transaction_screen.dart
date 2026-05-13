import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/transaction_model.dart';

import '../../../../services/firestore_service.dart';

import '../widgets/amount_display.dart';
import '../widgets/amount_keyboard.dart';
import '../widgets/category_grid.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/note_input.dart';
import '../widgets/transaction_type_toggle.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final FirestoreService firestoreService = FirestoreService();

  bool isExpense = true;

  String amount = '0';

  DateTime selectedDate = DateTime.now();

  String selectedCategory = 'Ăn uống';

  final TextEditingController noteController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'icon': '🍜', 'title': 'Ăn uống'},

    {'icon': '🚗', 'title': 'Di chuyển'},

    {'icon': '🛍️', 'title': 'Mua sắm'},

    {'icon': '🎮', 'title': 'Giải trí'},

    {'icon': '📚', 'title': 'Học phí'},

    {'icon': '💊', 'title': 'Y tế'},
  ];

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
          amount += value;
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
        return AmountKeyboard(
          onTap: (value) {
            onKeyboardTap(value);
          },
        );
      },
    );
  }

  Future<void> saveTransaction() async {
    if (amount == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,

          content: Text('Vui lòng nhập số tiền'),
        ),
      );

      return;
    }

    try {
      final transaction = TransactionModel(
        id: const Uuid().v4(),

        userId: 'demo-user',

        amount: double.tryParse(amount) ?? 0,

        type: isExpense ? TransactionType.expense : TransactionType.income,

        categoryId: selectedCategory,

        categoryName: selectedCategory,

        note: noteController.text,

        date: selectedDate,
      );

      await firestoreService.addTransaction(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,

          content: Text('Lưu giao dịch thành công'),
        ),
      );

      setState(() {
        amount = '0';

        selectedCategory = 'Ăn uống';

        isExpense = true;

        selectedDate = DateTime.now();
      });

      noteController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DatePickerField(
                            selectedDate: selectedDate,

                            onSelectDate: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(child: NoteInput(controller: noteController)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    TransactionTypeToggle(
                      isExpense: isExpense,

                      onChanged: (value) {
                        setState(() {
                          isExpense = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        openKeyboard();
                      },

                      child: AmountDisplay(amount: amount),
                    ),

                    const SizedBox(height: 16),

                    CategoryGrid(
                      categories: categories,

                      selectedCategory: selectedCategory,

                      onSelect: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,

                      height: 56,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),

                        onPressed: saveTransaction,

                        child: const Text(
                          'Lưu giao dịch',

                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
