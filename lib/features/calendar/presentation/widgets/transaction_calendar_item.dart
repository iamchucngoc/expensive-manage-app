import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionCalendarItem
    extends StatelessWidget {

  final Map<String, dynamic> item;

  const TransactionCalendarItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: Slidable(

        endActionPane: ActionPane(
          motion:
              const DrawerMotion(),

          children: [

            SlidableAction(
              onPressed: (context) {

              },

              backgroundColor:
                  Colors.red,

              icon: Icons.delete,

              label: 'Xóa',
            ),
          ],
        ),

        child: GestureDetector(

          onTap: () {

            Navigator.pushNamed(
              context,
              '/add-transaction',
            );
          },

          child: Container(
            padding:
                const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Row(
              children: [

                CircleAvatar(
                  radius: 24,

                  backgroundColor:
                      Colors.orange
                          .withOpacity(
                    0.15,
                  ),

                  child: Text(
                    item['icon'],
                    style:
                        const TextStyle(
                      fontSize: 20,
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
                        item['title'],

                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        item['subtitle'],

                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  item['amount'],

                  style: TextStyle(
                    color:
                        item['isExpense']
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
      ),
    );
  }
}