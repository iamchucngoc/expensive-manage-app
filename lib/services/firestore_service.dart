// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/transaction/data/models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collection = 'transactions';

  // Thêm giao dịch
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await firestore
          .collection(collection)
          .doc(transaction.id)
          .set(transaction.toMap());
    } catch (e) {
      print("Lỗi khi thêm giao dịch: $e");
      rethrow;
    }
  }

  // Lấy danh sách giao dịch
  Stream<List<TransactionModel>> getTransactions() {
    return firestore
        .collection(collection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Xóa giao dịch
  Future<void> deleteTransaction(String id) async {
    try {
      await firestore.collection(collection).doc(id).delete();
    } catch (e) {
      print("Lỗi khi xóa giao dịch: $e");
      rethrow;
    }
  }
}