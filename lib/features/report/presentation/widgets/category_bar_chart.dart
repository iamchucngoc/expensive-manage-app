// lib/features/report/presentation/widgets/category_bar_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryBarChart extends StatelessWidget {
  final Map<int, double> groupedData;
  final bool isYearMode;
  final DateTime currentDate;
  final Color color;

  const CategoryBarChart({
    super.key,
    required this.groupedData,
    required this.isYearMode,
    required this.currentDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    int maxItems = isYearMode ? 12 : DateTime(currentDate.year, currentDate.month + 1, 0).day; // 12 tháng hoặc số ngày trong tháng
    double maxY = groupedData.values.isEmpty ? 100 : groupedData.values.reduce((a, b) => a > b ? a : b) * 1.2;

    // Hiệu ứng Trượt từ Phải sang Trái
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: child,
        );
      },
      child: SizedBox(
        height: 200,
        // Cuộn ngang nếu biểu đồ quá dài (như 31 ngày)
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            width: maxItems * 40.0 < MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width : maxItems * 40.0,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false), // Có thể bật lên để chạm xem chi tiết
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Ẩn cột Y bên trái cho sạch
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(maxItems, (index) {
                  int key = index + 1; // Ngày 1->31 hoặc Tháng 1->12
                  double val = groupedData[key] ?? 0.0;
                  return BarChartGroupData(
                    x: key,
                    barRods: [
                      BarChartRodData(
                        toY: val,
                        color: color,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}