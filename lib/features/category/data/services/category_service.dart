import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collection = "categories";


  Stream<List<CategoryModel>> getCategories(String userId) {
    return firestore
        .collection(collection)
        .where('userId', isEqualTo: userId) 
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => CategoryModel.fromMap(e.data()))
              .toList(),
        );
  }

  Future<void> addCategory(CategoryModel category) async {
    await firestore.collection(collection).doc(category.id).set(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await firestore.collection(collection).doc(id).delete();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await firestore.collection(collection).doc(category.id).update(category.toMap());
  }


  Future<void> seedDefaultCategories(String userId) async {
    final snapshot = await firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .get();

    
    if (snapshot.docs.isNotEmpty) {
      return;
    }

  
    final defaults = [
      CategoryModel(
        id: "expense_food_$userId",
        userId: userId,
        name: "Ăn uống",
        icon: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2zM16 6v8h2.5v8H21V2c-2.76 0-5 2.24-5 4"/></svg>',
        type: "expense",
        colorHex: "#FF6B6B",
      ),
      CategoryModel(
        id: "expense_transport_$userId",
        userId: userId,
        name: "Di chuyển",
        icon: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16m11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5M5 11l1.5-4.5h11L19 11z"/></svg>',
        type: "expense",
        colorHex: "#4ECDC4",
      ),
      CategoryModel(
        id: "income_salary_$userId",
        userId: userId,
        name: "Lương",
        icon: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M21 7.28V5c0-1.1-.9-2-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14c1.1 0 2-.9 2-2v-2.28A2 2 0 0 0 22 15V9a2 2 0 0 0-1-1.72M20 9v6h-7V9zM5 19V5h14v2h-6c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h6v2z"/><circle cx="16" cy="12" r="1.5" fill="currentColor"/></svg>',
        type: "income",
        colorHex: "#FDCB6E",
      ),
    ];

    for (final category in defaults) {
      await addCategory(category);
    }
  }
}