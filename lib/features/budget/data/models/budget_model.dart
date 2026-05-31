// lib/features/budget/data/models/budget_model.dart

class BudgetModel {
  final String id;
  final double amount;
  final int month;
  final int year;

  BudgetModel({
    required this.id,
    required this.amount,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "amount": amount,
      "month": month,
      "year": year,
    };
  }

  factory BudgetModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return BudgetModel(
      id: map["id"],
      amount: (map["amount"] ?? 0).toDouble(),
      month: map["month"] ?? 1,
      year: map["year"] ?? 2025,
    );
  }
}