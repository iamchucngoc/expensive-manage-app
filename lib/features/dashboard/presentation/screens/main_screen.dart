import 'package:flutter/material.dart';

import '../../../transaction/presentation/screens/add_transaction_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../report/presentation/screens/report_screen.dart';
import '../../../setting/presentation/screens/setting_screen.dart';

import '../../../../widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [
    const AddTransactionScreen(),
    const CalendarScreen(),
    const ReportScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: Column(
        children: [

          Container(
            width: double.infinity,
            color: Colors.black,

            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

            child: const SafeArea(
              bottom: false,

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  'MoneyNote',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: screens[currentIndex],
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}