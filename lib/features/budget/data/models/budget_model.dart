// lib/features/budget/data/models/budget_model.dart
class BudgetModel {
  final String id;
  final String userId;
  final int month;
  final int year;
  final double totalBudget;
  final Map<String, double> categoryBudgets;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.totalBudget,
    required this.categoryBudgets,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'month': month,
      'year': year,
      'totalBudget': totalBudget,
      'categoryBudgets': categoryBudgets,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      month: map['month'] ?? 1,
      year: map['year'] ?? 2024,
      totalBudget: (map['totalBudget'] ?? 0).toDouble(),
      categoryBudgets: Map<String, double>.from(
          map['categoryBudgets']?.map((key, value) => MapEntry(key, value.toDouble())) ?? {}),
    );
  }
}