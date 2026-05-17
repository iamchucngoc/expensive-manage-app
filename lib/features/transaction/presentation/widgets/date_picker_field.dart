import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {

  final DateTime selectedDate;

  final Function(DateTime) onSelectDate;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  Future<void> pickDate(
    BuildContext context,
  ) async {

    final pickedDate =
        await showDatePicker(
      context: context,

      initialDate: selectedDate,

      firstDate: DateTime(2020),

      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      onSelectDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {

    final formattedDate =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    return GestureDetector(
      onTap: () {
        pickDate(context);
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(14),
        ),

        child: Row(
          children: [

            const Icon(
              Icons.calendar_month,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                formattedDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}