import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../services/firestore_service.dart';

import '../../../transaction/data/models/transaction_model.dart';

class TransactionCalendarItem
    extends StatelessWidget {

  final TransactionModel
      transaction;

  const TransactionCalendarItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {

    final isExpense =
        transaction.type ==
            TransactionType.expense;

    return Slidable(

      endActionPane: ActionPane(
        motion:
            const StretchMotion(),

        children: [

          SlidableAction(
            onPressed: (_) async {

              await FirestoreService()
                  .deleteTransaction(
                transaction.id,
              );
            },

            backgroundColor:
                Colors.red,

            icon: Icons.delete,
          ),
        ],
      ),

      child: GestureDetector(

        onTap: () {

          // sau này:
          // navigate sang edit transaction
        },

        child: Container(
          margin:
              const EdgeInsets.only(
            bottom: 12,
          ),

          padding:
              const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),

          child: Row(
            children: [

              Container(
                width: 50,
                height: 50,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey
                          .shade100,

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: const Center(
                  child: Text(
                    '💸',

                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(
                      transaction
                          .categoryName,

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      transaction.note ??
                          '',
                    ),
                  ],
                ),
              ),

              Text(
                '${isExpense ? '-' : '+'}${transaction.amount.toInt()}đ',

                style: TextStyle(
                  color: isExpense
                      ? Colors.red
                      : Colors.green,

                  fontWeight:
                      FontWeight.bold,

                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}