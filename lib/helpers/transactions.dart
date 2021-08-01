import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/transaction.dart' as m;

class TransactionsHelper {
  static Future<List<m.Transaction>> searchUserTransactions({
    required String userId,
    int? limit,
    DateTime? from,
    DateTime? to,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Fetch the collection
      var query = firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }
      if (from != null) {
        query = query.where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(from));
      }
      if (to != null) {
        query =
            query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
      }

      var collection = await query.get();

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

  static Future<List<m.Transaction>> getTransactionsByMonth(
    String userId,
    int month,
    int year,
  ) async {
    var start = DateTime(year, month, 1);
    var end = DateTime(year, month + 1, 0);
    try {
      var transactions = await TransactionsHelper.searchUserTransactions(
        userId: userId,
        from: start,
        to: end,
      );
      return transactions;
    } catch (e) {
      throw e;
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

  static Future<double> getExpensesByMonth(
    String userId,
    int year,
    int month,
  ) async {
    Iterable<m.Transaction> monthTransactions =
        (await getTransactionsByMonth(userId, month, year))
            .where((element) => element.categoryType == CategoryType.Expenses);

    double expenses = 0.0;
    if (monthTransactions.length > 0) {
      monthTransactions.forEach((element) {
        expenses += element.amount;
      });
    }

    return expenses;
  }
}
