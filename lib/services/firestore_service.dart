import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/transaction/data/models/transaction_model.dart';
class FirestoreService {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> addTransaction(
    TransactionModel transaction,
  ) async {

    await firestore
        .collection('transactions')
        .doc(transaction.id)
        .set(
          transaction.toMap(),
        );
  }

  Future<List<TransactionModel>>
      getTransactions() async {

    final snapshot =
        await firestore
            .collection('transactions')
            .get();

    return snapshot.docs.map((doc) {

      return TransactionModel.fromMap(
        doc.data(),
      );
    }).toList();
  }
}