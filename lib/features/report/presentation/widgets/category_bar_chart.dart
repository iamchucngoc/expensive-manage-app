// lib/features/report/presentation/widgets/category_bar_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../transaction/data/models/transaction_model.dart';

class CategoryBarChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const CategoryBarChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Nhóm theo ngày
    final Map<String, double> dailyAmount = {};
    for (var t in transactions) {
      final key = "${t.date.day}/${t.date.month}";
      dailyAmount[key] = (dailyAmount[key] ?? 0) + t.amount;
    }

    final spots = dailyAmount.entries.map((e) {
      final day = int.parse(e.key.split('/')[0]);
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: Colors.orange,
            width: 20,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (dailyAmount.values.isEmpty ? 100 : dailyAmount.values.reduce((a, b) => a > b ? a : b)) * 1.2,
          barGroups: spots,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}