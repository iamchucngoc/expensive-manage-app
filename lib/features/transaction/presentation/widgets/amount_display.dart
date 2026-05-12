import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {

  final String amount;

  const AmountDisplay({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 28,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        children: [

          const Text(
            'Số tiền',

            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$amount đ',

            style: const TextStyle(
              color: Colors.red,
              fontSize: 42,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}