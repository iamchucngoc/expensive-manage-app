import 'package:flutter/material.dart';

import '../../../transaction/data/models/transaction_model.dart';

class MonthlySummary
    extends StatelessWidget {

  final List<TransactionModel>
      transactions;

  const MonthlySummary({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {

    double income = 0;

    double expense = 0;

    for (final item
        in transactions) {

      if (item.type ==
          TransactionType.income) {

        income += item.amount;
      }

      else {
        expense += item.amount;
      }
    }

    final total =
        income - expense;

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      padding:
          const EdgeInsets.symmetric(
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          Expanded(
            child: Column(
              children: [

                const Text(
                  'Thu nhập',
                ),

                const SizedBox(height: 6),

                Text(
                  '+${income.toInt()}đ',

                  style:
                      const TextStyle(
                    color: Colors.blue,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [

                const Text(
                  'Chi tiêu',
                ),

                const SizedBox(height: 6),

                Text(
                  '-${expense.toInt()}đ',

                  style:
                      const TextStyle(
                    color: Colors.red,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [

                const Text(
                  'Tổng',
                ),

                const SizedBox(height: 6),

                Text(
                  '${total >= 0 ? '+' : ''}${total.toInt()}đ',

                  style:
                      const TextStyle(
                    color: Colors.blue,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}