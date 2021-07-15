import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction.dart' as m;

class TransactionsHelper {
  static Future<List<m.Transaction>> searchUserTransactions(
      String userId, int limit) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final collection = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      List<m.Transaction> transactions = [];
      collection.docs.forEach((doc) {
        transactions.add(m.Transaction(
            id: doc.id,
            userId: userId,
            amount: doc.data()['amount'],
            categoryId: doc.data()['categoryId'],
            categoryType: doc.data()['categoryType'],
            date: doc.data()['date'],
            description: doc.data()['description']));
      });
      return transactions;
    } catch (e) {
      print('Error fetching transactions: ');
      print(e.toString());
      return [];
    }
  }

  static Future<void> addTransaction(m.Transaction transaction) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('transactions').add({
        'amount': transaction.amount,
        'userId': transaction.userId,
        'categoryId': transaction.categoryId,
        'categoryType': transaction.categoryType,
        'date': transaction.date.toIso8601String(),
        'description': transaction.description,
      });
    } catch (e) {
      print('Exception: ' + e.toString());
      throw e;
    }
  }
}
