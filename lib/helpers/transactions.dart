import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/transaction.dart' as m;

class TransactionsHelper {
  static Future<List<m.Transaction>> searchUserTransactions(
      String userId, int limit) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Fetch de collection
      final collection = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      // Transform into a list of transactions
      List<m.Transaction> transactions = [];

      collection.docs.forEach((doc) {
        transactions.add(m.Transaction(
            id: doc.id,
            userId: userId,
            amount: doc.data()['amount'],
            categoryId: doc.data()['categoryId'],
            categoryType:
                Category.parseCategoryType(doc.data()['categoryType']),
            date: (doc.data()['date'] as Timestamp).toDate(),
            description: doc.data()['description']));
      });

      return transactions;
    } catch (e) {
      print('Error fetching transactions: ');
      print(e.toString());
      return [];
    }
  }

  static Future<m.Transaction> addTransaction(
      double amount,
      String userId,
      String categoryId,
      CategoryType categoryType,
      DateTime date,
      String description) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final doc = await firestore.collection('transactions').add({
        'amount': amount,
        'userId': userId,
        'categoryId': categoryId,
        'categoryType': categoryType.valueAsString(),
        'date': Timestamp.fromDate(date),
        'description': description,
      });

      return m.Transaction(
        id: doc.id,
        userId: userId,
        amount: amount,
        categoryId: categoryId,
        categoryType: categoryType,
        date: date,
        description: description,
      );
    } catch (e) {
      print('Exception: ' + e.toString());
      throw e;
    }
  }

  static Future<void> deleteTransaction(String id) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      print('SPLAN: Exception: ' + e.toString());
      throw e;
    }
  }
}
