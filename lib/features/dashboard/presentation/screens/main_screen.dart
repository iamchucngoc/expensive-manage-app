// lib/features/main/presentation/screens/main_screen.dart
import 'package:flutter/material.dart';
import '../../../transaction/presentation/screens/add_transaction_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../../widgets/custom_bottom_nav.dart';
import '../../../setting/presentation/screens/setting_screen.dart';
import '../../../report/presentation/screens/report_screen.dart';
import '../../../budget/presentation/screens/budget_screen.dart';

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
    const BudgetScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color lightBg = primaryColor.withOpacity(0.1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: lightBg,
            child: SafeArea(
              bottom: false, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  'NoraNote',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          Expanded(child: screens[currentIndex]),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}