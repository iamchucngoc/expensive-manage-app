import 'package:flutter/material.dart';

import '../../../transaction/data/models/transaction_model.dart';

import 'transaction_calendar_item.dart';

class GroupedTransactionList
    extends StatelessWidget {

  final List<TransactionModel>
      transactions;

  const GroupedTransactionList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {

    final grouped =
        <String,
            List<TransactionModel>>{};

    for (final transaction
        in transactions) {

      final key =
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}';

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(transaction);
    }

    final keys =
        grouped.keys.toList();

    return ListView.builder(
      padding:
          const EdgeInsets.all(12),

      itemCount: keys.length,

      itemBuilder: (context, index) {

        final key = keys[index];

        final items =
            grouped[key]!;

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 10,
              ),

              child: Text(
                key,

                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            ...items.map(
              (e) =>
                  TransactionCalendarItem(
                transaction: e,
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}