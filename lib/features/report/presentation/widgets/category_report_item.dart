import 'package:flutter/material.dart';

class CategoryReportItem
    extends StatelessWidget {
  final String categoryName;
  final double amount;
  final double percent;
  final VoidCallback onTap;

  const CategoryReportItem({
    super.key,
    required this.categoryName,
    required this.amount,
    required this.percent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin:
            const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 18,
        ),

        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "🛍️",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    categoryName,

                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .end,

                  children: [
                    Text(
                      "${amount.toInt()}k",

                      style:
                          const TextStyle(
                        color: Colors.red,
                        fontWeight:
                            FontWeight
                                .bold,

                        fontSize: 24,
                      ),
                    ),

                    Text(
                      "${percent.toStringAsFixed(1)}%",

                      style: TextStyle(
                        color:
                            Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              child:
                  LinearProgressIndicator(
                value: percent / 100,

                minHeight: 10,

                backgroundColor:
                    Colors.grey[300],

                color:
                    Colors.cyanAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}