import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'error.dart';
import 'loading.dart';
import '../widgets/transaction_list.dart';
import '../widgets/chart_overview.dart';
import '../models/transaction.dart';
import '../helpers/transactions.dart';

class OverviewScreen extends StatefulWidget {
  static const routeName = '/overview';
  const OverviewScreen();

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Transaction> _filterByCurrentMonth(List<Transaction> transactions) {
    List<Transaction> currentMonthTransactions = [];
    var currentDate = DateTime.now();
    transactions.forEach((transaction) {
      if (transaction.date.month == currentDate.month &&
          transaction.date.year == currentDate.year) {
        currentMonthTransactions.add(transaction);
      }
    });
    return currentMonthTransactions;
  }

  Future<List<Transaction>> _getTransactions(String userId, int limit) async {
    return await TransactionsHelper.searchUserTransactions(userId, limit);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
            future: _getTransactions(user.currentUser!.uid, 30),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingScreen();
              } else if (snap.hasError) {
                return ErrorScreen(snap.error.toString());
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChartOverview(
                      _filterByCurrentMonth(snap.data as List<Transaction>)),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Recent transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  TransactionList(snap.data as List<Transaction>)
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
