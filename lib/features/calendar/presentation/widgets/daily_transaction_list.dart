import 'package:flutter/material.dart';

import '../../../transaction/data/models/transaction_model.dart';

import '../../../../services/firestore_service.dart';

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

    return StreamBuilder<
        List<TransactionModel>>(
      stream:
          FirestoreService()
              .getTransactions(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        final transactions =
            snapshot.data!;

        final filtered =
            transactions.where((e) {

          return e.date.year ==
                  selectedDate.year &&
              e.date.month ==
                  selectedDate.month &&
              e.date.day ==
                  selectedDate.day;
        }).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              'Không có giao dịch',
            ),
          );
        }

        return ListView.builder(
          padding:
              const EdgeInsets.all(12),

          itemCount: filtered.length,

          itemBuilder: (context, index) {

            final transaction =
                filtered[index];

            return TransactionCalendarItem(
              transaction:
                  transaction,
            );
          },
        );
      },
    );
  }
}