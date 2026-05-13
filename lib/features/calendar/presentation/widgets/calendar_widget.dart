import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {

  final DateTime selectedDate;

  final Function(DateTime)
      onSelectDate;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(12),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: TableCalendar(
        firstDay:
            DateTime.utc(2020),

        lastDay:
            DateTime.utc(2035),

        focusedDay:
            selectedDate,

        selectedDayPredicate:
            (day) {

          return isSameDay(
            selectedDate,
            day,
          );
        },

        onDaySelected:
            (selectedDay, focusedDay) {

          onSelectDate(
            selectedDay,
          );
        },

        headerStyle:
            const HeaderStyle(
          titleCentered: true,

          formatButtonVisible:
              false,
        ),

        calendarStyle:
            CalendarStyle(

          todayDecoration:
              BoxDecoration(
            color:
                Colors.blue
                    .withOpacity(0.2),

            shape:
                BoxShape.circle,
          ),

          selectedDecoration:
              const BoxDecoration(
            color: Colors.blue,

            shape:
                BoxShape.circle,
          ),
        ),
      ),
    );
  }
}