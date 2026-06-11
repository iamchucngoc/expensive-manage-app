// lib/features/transaction/data/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor; 
  final String? note;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor, 
    this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'categoryColor': categoryColor,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

factory TransactionModel.fromMap(Map<String, dynamic> map) {

    DateTime parsedDate = DateTime.now();
    if (map['date'] != null) {
      if (map['date'] is Timestamp) {
        parsedDate = (map['date'] as Timestamp).toDate(); 
      } else if (map['date'] is String) {
        parsedDate = DateTime.tryParse(map['date']) ?? DateTime.now(); 
      }
    }

    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      categoryIcon: map['categoryIcon'] ?? '',
      categoryColor: map['categoryColor'] ?? '#000000',
      note: map['note'],
      date: parsedDate, 
    );
  }
}