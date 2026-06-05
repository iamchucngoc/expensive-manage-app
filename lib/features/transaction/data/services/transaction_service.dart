import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final String collection =
      'transactions';

  Stream<List<TransactionModel>>
      getTransactions() {
    return firestore
        .collection(collection)
        .orderBy(
          'date',
          descending: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> addTransaction(
    TransactionModel transaction,
  ) async {
    await firestore
        .collection(collection)
        .doc(transaction.id)
        .set(
          transaction.toMap(),
        );
  }

  Future<void> updateTransaction(
    TransactionModel transaction,
  ) async {
    await firestore
        .collection(collection)
        .doc(transaction.id)
        .update(
          transaction.toMap(),
        );
  }

  Future<void> deleteTransaction(
    String id,
  ) async {
    await firestore
        .collection(collection)
        .doc(id)
        .delete();
  }
}