import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {

  final TextEditingController controller;

  const NoteInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: 'Ghi chú',

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),

          borderSide: BorderSide.none,
        ),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
      ),
    );
  }
}