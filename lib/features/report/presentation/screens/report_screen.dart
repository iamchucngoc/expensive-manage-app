// lib/features/report/presentation/screens/report_screen.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../transaction/data/services/transaction_service.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../widgets/category_report_item.dart';
import 'category_detail_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() =>
      _ReportScreenState();
}

class _ReportScreenState
    extends State<ReportScreen> {
  bool isExpense = true;
  bool isYearMode = false;

  DateTime currentDate = DateTime.now();

  List<TransactionModel> _filter(
    List<TransactionModel> all,
  ) {
    return all.where((t) {
      if (isYearMode) {
        return t.date.year ==
            currentDate.year;
      }

      return t.date.year ==
              currentDate.year &&
          t.date.month ==
              currentDate.month;
    }).toList();
  }

  void prev() {
    setState(() {
      if (isYearMode) {
        currentDate = DateTime(
          currentDate.year - 1,
        );
      } else {
        currentDate = DateTime(
          currentDate.year,
          currentDate.month - 1,
        );
      }
    });
  }

  void next() {
    setState(() {
      if (isYearMode) {
        currentDate = DateTime(
          currentDate.year + 1,
        );
      } else {
        currentDate = DateTime(
          currentDate.year,
          currentDate.month + 1,
        );
      }
    });
  }

  String money(double value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    }

    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}k";
    }

    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff5f5f5),

      body: SafeArea(
        child:
            StreamBuilder<
                List<TransactionModel>>(
          stream:
              TransactionService()
                  .getTransactions(),

          builder: (
            context,
            snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            final all =
                snapshot.data!;

            final transactions =
                _filter(all);

            final expenseList =
                transactions
                    .where(
                      (t) =>
                          t.type ==
                          TransactionType
                              .expense,
                    )
                    .toList();

            final incomeList =
                transactions
                    .where(
                      (t) =>
                          t.type ==
                          TransactionType
                              .income,
                    )
                    .toList();

            final totalExpense =
                expenseList.fold(
              0.0,
              (sum, t) =>
                  sum + t.amount,
            );

            final totalIncome =
                incomeList.fold(
              0.0,
              (sum, t) =>
                  sum + t.amount,
            );

            final balance =
                totalIncome -
                    totalExpense;

            final currentList =
                isExpense
                    ? expenseList
                    : incomeList;

            final categoryMap =
                <String, double>{};

            for (var t in currentList) {
              categoryMap[t
                      .categoryName] =
                  (categoryMap[t
                              .categoryName] ??
                          0) +
                      t.amount;
            }

            return Column(
              children: [
                _buildHeader(),

                Expanded(
                  child:
                      SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildMonthBox(),

                        const SizedBox(
                          height: 14,
                        ),

                        _buildSummary(
                          totalIncome,
                          totalExpense,
                          balance,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        _buildToggle(),

                        const SizedBox(
                          height: 24,
                        ),

                        _buildChart(
                          categoryMap,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        ...categoryMap.entries.map(
                          (entry) {
                            final total =
                                isExpense
                                    ? totalExpense
                                    : totalIncome;

                            final percent =
                                total >
                                        0
                                    ? ((entry.value /
                                                total) *
                                            100)
                                        .toDouble()
                                    : 0.0;

                            return CategoryReportItem(
                              categoryName:
                                  entry.key,

                              amount:
                                  entry.value,

                              percent:
                                  percent,

                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            CategoryDetailScreen(
                                      categoryName:
                                          entry.key,

                                      transactions:
                                          currentList
                                              .where(
                                                (
                                                  t,
                                                ) =>
                                                    t.categoryName ==
                                                    entry.key,
                                              )
                                              .toList(),

                                      isExpense:
                                          isExpense,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 72,
      color: Colors.white,

      alignment: Alignment.center,

      child: Container(
        height: 46,

        padding: const EdgeInsets.all(4),

        decoration: BoxDecoration(
          color: Colors.grey[200],

          borderRadius:
              BorderRadius.circular(14),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            _modeButton(
              "Hàng Tháng",
              !isYearMode,
              () {
                setState(() {
                  isYearMode = false;
                });
              },
            ),

            _modeButton(
              "Hàng Năm",
              isYearMode,
              () {
                setState(() {
                  isYearMode = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeButton(
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color:
              selected
                  ? Colors.orange
                  : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
            12,
          ),

          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.orange
                          .withOpacity(0.25),

                      blurRadius: 6,

                      offset: const Offset(
                        0,
                        2,
                      ),
                    ),
                  ]
                  : [],
        ),

        child: Text(
          text,

          style: TextStyle(
            color:
                selected
                    ? Colors.white
                    : Colors.black54,

            fontWeight:
                FontWeight.bold,

            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthBox() {
    final text =
        isYearMode
            ? "${currentDate.year}"
            : "${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";

    return Container(
      margin:
          const EdgeInsets.all(16),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xfff7f1e3,
        ),

        borderRadius:
            BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: prev,

            child: const Icon(
              Icons.chevron_left,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                text,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: next,

            child: const Icon(
              Icons.chevron_right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(
    double income,
    double expense,
    double balance,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              "Thu nhập",
              money(income),
              Colors.green,
            ),
          ),

          Expanded(
            child: _summaryItem(
              "Chi tiêu",
              money(expense),
              Colors.red,
            ),
          ),

          Expanded(
            child: _summaryItem(
              "Còn lại",
              money(balance),
              Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    String title,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          title,

          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,

          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Center(
      child: Container(
        height: 42,

        padding: const EdgeInsets.all(
          4,
        ),

        decoration: BoxDecoration(
          color: Colors.grey[200],

          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = true;
                });
              },

              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 200,
                ),

                width: 80,

                decoration: BoxDecoration(
                  color:
                      isExpense
                          ? Colors.red
                          : Colors.transparent,

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),

                child: Center(
                  child: Text(
                    "Chi",

                    style: TextStyle(
                      color:
                          isExpense
                              ? Colors.white
                              : Colors.black54,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = false;
                });
              },

              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 200,
                ),

                width: 80,

                decoration: BoxDecoration(
                  color:
                      !isExpense
                          ? Colors.green
                          : Colors.transparent,

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),

                child: Center(
                  child: Text(
                    "Thu",

                    style: TextStyle(
                      color:
                          !isExpense
                              ? Colors.white
                              : Colors.black54,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    Map<String, double> data,
  ) {
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          "Chưa có dữ liệu",
        ),
      );
    }

    final colors = [
      Colors.orange,
      Colors.teal,
      Colors.red,
      Colors.blue,
      Colors.purple,
    ];

    int index = 0;

    final sections =
        data.entries.map((e) {
      final color =
          colors[index %
              colors.length];

      index++;

      return PieChartSectionData(
        value: e.value,

        title: '',

        color: color,

        radius: 90,
      );
    }).toList();

    return SizedBox(
      height: 300,

      child: PieChart(
        PieChartData(
          sections: sections,

          centerSpaceRadius: 55,

          sectionsSpace: 2,
        ),
      ),
    );
  }
}
