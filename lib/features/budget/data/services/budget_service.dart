// lib/features/budget/data/services/budget_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

class BudgetService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static bool shouldWarnBudgetExceeded({
    required double newAmount,
    required double categoryBudget,
    required double currentMonthlySpend,
  }) {
    if (newAmount <= 0 || categoryBudget <= 0) {
      return false;
    }

    return currentMonthlySpend + newAmount > categoryBudget;
  }

  // Lấy ngân sách theo tháng/năm
  Stream<BudgetModel?> getBudget(String userId, int month, int year) {
    String docId = '${userId}_${year}_$month';
    return _db.collection('budgets').doc(docId).snapshots().map((doc) {
      if (doc.exists) {
        return BudgetModel.fromMap(doc.data()!);
      }
      return null; // Chưa thiết lập
    });
  }

  // Lưu hoặc cập nhật ngân sách
  Future<void> saveBudget(BudgetModel budget) async {
    String docId = '${budget.userId}_${budget.year}_${budget.month}';
    await _db.collection('budgets').doc(docId).set(budget.toMap());
  }
}