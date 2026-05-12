import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({super.key});

  @override
  State<DatePickerField> createState() =>
      _DatePickerFieldState();
}

class _DatePickerFieldState
    extends State<DatePickerField> {

  DateTime selectedDate = DateTime.now();

  Future<void> pickDate() async {

    final pickedDate = await showDatePicker(
      context: context,

      initialDate: selectedDate,

      firstDate: DateTime(2020),

      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final formattedDate =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    return GestureDetector(
      onTap: pickDate,

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
              color: Colors.black87,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                formattedDate,

                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}