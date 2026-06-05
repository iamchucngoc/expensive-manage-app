enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;

  final String categoryId;
  final String categoryName;
  final String categoryIcon;

  final String? note;

  final DateTime date;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    this.note,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionModel(
      id: map['id'],
      userId: map['userId'],
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.byName(
        map['type'],
      ),
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      categoryIcon:
          map['categoryIcon'] ?? '💸',
      note: map['note'],
      date: DateTime.parse(
        map['date'],
      ),
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
    );
  }
}