import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final String collection =
      "categories";

  Stream<List<CategoryModel>>
      getCategories() {
    return firestore
        .collection(collection)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (e) =>
                        CategoryModel.fromMap(
                      e.data(),
                    ),
                  )
                  .toList(),
        );
  }

  Future<void> addCategory(
    CategoryModel category,
  ) async {
    await firestore
        .collection(collection)
        .doc(category.id)
        .set(category.toMap());
  }

  Future<void> deleteCategory(
    String id,
  ) async {
    await firestore
        .collection(collection)
        .doc(id)
        .delete();
  }

  Future<void> updateCategory(
    CategoryModel category,
  ) async {
    await firestore
        .collection(collection)
        .doc(category.id)
        .update(category.toMap());
  }

  Future<void>
      seedDefaultCategories() async {
    final snapshot =
        await firestore
            .collection(collection)
            .get();

    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final defaults = [
      CategoryModel(
        id: "expense_food",
        name: "Ăn uống",
        icon: "🍜",
        type: "expense",
      ),
      CategoryModel(
        id: "expense_transport",
        name: "Di chuyển",
        icon: "🚗",
        type: "expense",
      ),
      CategoryModel(
        id: "expense_shopping",
        name: "Mua sắm",
        icon: "🛍️",
        type: "expense",
      ),
      CategoryModel(
        id: "expense_entertainment",
        name: "Giải trí",
        icon: "🎮",
        type: "expense",
      ),
      CategoryModel(
        id: "expense_health",
        name: "Y tế",
        icon: "💊",
        type: "expense",
      ),
      CategoryModel(
        id: "income_salary",
        name: "Lương",
        icon: "💰",
        type: "income",
      ),
      CategoryModel(
        id: "income_bonus",
        name: "Thưởng",
        icon: "🎁",
        type: "income",
      ),
      CategoryModel(
        id: "income_invest",
        name: "Đầu tư",
        icon: "📈",
        type: "income",
      ),
    ];

    for (final category in defaults) {
      await addCategory(category);
    }
  }
}