import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  const NoteInput({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,

          icon: Icon(Icons.edit_note),

          hintText: 'Ghi chú',
        ),
      ),
    );
  }
}