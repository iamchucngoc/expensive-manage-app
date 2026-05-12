import 'package:flutter/material.dart';

import '../widgets/amount_display.dart';
import '../widgets/amount_keyboard.dart';
import '../widgets/category_grid.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/note_input.dart';
import '../widgets/transaction_type_toggle.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

  bool isExpense = true;

  String amount = '0';

  String selectedCategory = 'Ăn uống';

  final List<Map<String, dynamic>> categories = [
    {'icon': '🍜', 'title': 'Ăn uống'},
    {'icon': '🚗', 'title': 'Di chuyển'},
    {'icon': '🛍️', 'title': 'Mua sắm'},
    {'icon': '🎮', 'title': 'Giải trí'},
    {'icon': '📚', 'title': 'Học phí'},
    {'icon': '💲', 'title': 'Y tế'},
  ];

  void onKeyboardTap(String value) {
    setState(() {

      if (value == 'C') {
        amount = '0';
      }

      else if (value == '⌫') {

        if (amount.length > 1) {
          amount =
              amount.substring(0, amount.length - 1);
        }

        else {
          amount = '0';
        }
      }

      else {

        if (amount == '0') {
          amount = value;
        }

        else {
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
                      children: const [

                        Expanded(
                          child: DatePickerField(),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: NoteInput(),
                        ),
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

                      child: AmountDisplay(
                        amount: amount,
                      ),
                    ),

                    const SizedBox(height: 16),

                    CategoryGrid(
                      categories: categories,

                      selectedCategory:
                          selectedCategory,

                      onSelect: (value) {
                        setState(() {
                          selectedCategory =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                        ),

                        onPressed: () {},

                        child: const Text(
                          'Lưu giao dịch',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
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