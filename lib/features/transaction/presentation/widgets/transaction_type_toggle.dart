import 'package:flutter/material.dart';

class TransactionTypeToggle extends StatelessWidget {
  final bool isExpense;
  final Function(bool) onChanged;

  const TransactionTypeToggle({
    super.key,
    required this.isExpense,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFFF6492);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('Tiền chi', isExpense, () => onChanged(true), true),
        _buildButton('Tiền thu', !isExpense, () => onChanged(false), false),
      ],
    );
  }

  Widget _buildButton(String text, bool isSelected, VoidCallback onTap, bool isExpenseSide) {
    const primaryPink = Color(0xFFFF6492);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryPink : primaryPink.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: isExpenseSide ? const Radius.circular(8) : Radius.zero,
            bottomLeft: isExpenseSide ? const Radius.circular(8) : Radius.zero,
            topRight: !isExpenseSide ? const Radius.circular(8) : Radius.zero,
            bottomRight: !isExpenseSide ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryPink,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}