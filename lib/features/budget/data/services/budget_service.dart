// lib/features/budget/data/services/budget_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/budget_model.dart';

class BudgetService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final String collection = "budgets";

  Stream<List<BudgetModel>>
      getBudgets() {
    return firestore
        .collection(collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                BudgetModel.fromMap(
              doc.data(),
            ),
          )
          .toList();
    });
  }

  Future<void> saveBudget(
    BudgetModel budget,
  ) async {
    await firestore
        .collection(collection)
        .doc(budget.id)
        .set(budget.toMap());
  }
}