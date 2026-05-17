import 'package:flutter/material.dart';

class AmountKeyboard extends StatelessWidget {

  final Function(String) onTap;

  const AmountKeyboard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '+', '0', '-',
      '×', '÷', '⌫',
      'C',
    ];

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      child: SafeArea(
        child: GridView.builder(
          shrinkWrap: true,

          physics:
              const NeverScrollableScrollPhysics(),

          itemCount: keys.length,

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
          ),

          itemBuilder: (context, index) {

            final key = keys[index];

            return GestureDetector(
              onTap: () => onTap(key),

              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Center(
                  child: Text(
                    key,

                    style: TextStyle(
                      fontSize: 28,

                      color: key == 'C'
                          ? Colors.red
                          : Colors.black,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}