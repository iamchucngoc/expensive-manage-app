import 'package:flutter/material.dart';

class TransactionTypeToggle
    extends StatelessWidget {
  final bool isExpense;

  final Function(bool) onChanged;

  const TransactionTypeToggle({
    super.key,
    required this.isExpense,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),

              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: isExpense
                      ? Colors.red
                      : Colors.transparent,

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Text(
                  'Chi tiêu',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: isExpense
                        ? Colors.white
                        : Colors.black54,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),

              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: !isExpense
                      ? Colors.green
                      : Colors.transparent,

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Text(
                  'Thu nhập',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: !isExpense
                        ? Colors.white
                        : Colors.black54,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}