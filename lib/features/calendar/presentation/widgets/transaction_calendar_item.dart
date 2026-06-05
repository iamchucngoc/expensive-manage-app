import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/data/services/transaction_service.dart';

class TransactionCalendarItem extends StatelessWidget {
  final TransactionModel transaction;

  final VoidCallback? onEdit;

  const TransactionCalendarItem({
    super.key,
    required this.transaction,
    this.onEdit,
  });

  Future<void> _deleteTransaction(
    BuildContext context,
  ) async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Xóa giao dịch',
          ),
          content: const Text(
            'Bạn có chắc muốn xóa giao dịch này?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Hủy',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),
              child: const Text(
                'Xóa',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await TransactionService()
        .deleteTransaction(
      transaction.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isExpense =
        transaction.type ==
            TransactionType.expense;

    return Slidable(
      key: ValueKey(
        transaction.id,
      ),

      endActionPane: ActionPane(
        motion:
            const StretchMotion(),

        children: [
          SlidableAction(
            onPressed: (_) =>
                _deleteTransaction(
              context,
            ),

            backgroundColor:
                Colors.red,

            foregroundColor:
                Colors.white,

            icon: Icons.delete,

            label: 'Xóa',
          ),
        ],
      ),

      child: GestureDetector(
        onTap: onEdit,

        child: Container(
          margin:
              const EdgeInsets.only(
            bottom: 12,
          ),

          padding:
              const EdgeInsets.all(
            14,
          ),

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

                child: Center(
                  child: Text(
                    transaction
                        .categoryIcon,

                    style:
                        const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 14,
              ),

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

                    if (transaction
                            .note !=
                        null &&
                        transaction
                            .note!
                            .isNotEmpty)
                      Text(
                        transaction
                            .note!,
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