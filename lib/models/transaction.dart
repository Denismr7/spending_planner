import './category.dart';

class Transaction {
  final String id;
  final String userId;
  final String categoryId;
  final CategoryType categoryType;
  final double amount;
  final DateTime date;
  final String description;

  const Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.categoryType,
    required this.date,
    required this.description,
  });
}
