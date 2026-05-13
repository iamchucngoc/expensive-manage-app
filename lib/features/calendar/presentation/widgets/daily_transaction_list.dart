import 'package:flutter/material.dart';

import 'transaction_calendar_item.dart';

class DailyTransactionList
    extends StatelessWidget {

  final DateTime selectedDate;

  const DailyTransactionList({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {

    final transactions = [

      {
        'title': 'Ăn uống',
        'subtitle': 'Ăn trưa',
        'amount': '-150k',
        'icon': '🍜',
        'isExpense': true,
      },

      {
        'title': 'Di chuyển',
        'subtitle': 'Xe buýt',
        'amount': '-30k',
        'icon': '🚗',
        'isExpense': true,
      },

      {
        'title': 'Lương',
        'subtitle': 'Lương tháng 4',
        'amount': '+15000k',
        'icon': '💰',
        'isExpense': false,
      },
    ];

    return Column(
      children: [

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
          ),

          child: Row(
            children: const [

              Text(
                'Danh sách giao dịch',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            itemCount:
                transactions.length,

            itemBuilder:
                (context, index) {

              final item =
                  transactions[index];

              return TransactionCalendarItem(
                item: item,
              );
            },
          ),
        ),
      ],
    );
  }
}