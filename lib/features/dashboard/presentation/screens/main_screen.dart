import 'package:flutter/material.dart';
import '../../../transaction/presentation/screens/add_transaction_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../../widgets/custom_bottom_nav.dart';
import '../../../setting/presentation/screens/setting_screen.dart';

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
    const Center(child: Text("Thống kê")),
    const Center(child: Text("Ngân sách")),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFFF6492);
    const lightPinkBg = Color(0xFFFCEEED);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: lightPinkBg,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 12),
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MoneyNote',
                  style: TextStyle(
                    color: primaryPink,
                    fontSize: 26,
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