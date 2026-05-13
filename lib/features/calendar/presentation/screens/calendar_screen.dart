import 'package:flutter/material.dart';

import '../widgets/calendar_widget.dart';
import '../widgets/daily_transaction_list.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState
    extends State<CalendarScreen> {

  DateTime selectedDate =
      DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xfff5f5f5),

      body: SafeArea(
        child: Column(
          children: [

            CalendarWidget(
              selectedDate:
                  selectedDate,

              onSelectDate: (date) {

                setState(() {
                  selectedDate =
                      date;
                });
              },
            ),

            Expanded(
              child:
                  DailyTransactionList(
                selectedDate:
                    selectedDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}