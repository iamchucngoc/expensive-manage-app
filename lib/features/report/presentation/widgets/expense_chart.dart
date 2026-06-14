// lib/features/report/presentation/widgets/expense_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../category/data/category_colors.dart';

class ExpensePieChart extends StatelessWidget {
  final List<MapEntry<String, Map<String, dynamic>>> data;
  final bool isExpense;

  const ExpensePieChart({super.key, required this.data, required this.isExpense});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text("Chưa có dữ liệu")));
    }

    final sections = data.map((e) {
      final color = hexToColor(e.value['color']);
      return PieChartSectionData(
        value: e.value['amount'],
        title: '', 
        color: color,
        radius: 60, 
      );
    }).toList();

    // Hiệu ứng Animation Scale (Nở ra)
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 50, 
                    sectionsSpace: 2,
                  ),
                ),
                
                Text(
                  isExpense ? "Chi tiêu" : "Thu nhập",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}