import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_note),
          label: 'Nhập',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Lịch',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Thống kê',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Cài đặt',
        ),
      ],
    );
  }
}