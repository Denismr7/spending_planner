import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/chart_overview.dart';
import '../mock.dart';
import '../models/transaction.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = '/overview';
  const OverviewScreen();

  List<Transaction> filterByCurrentMonth(List<Transaction> transactions) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChartOverview(filterByCurrentMonth(transactionsMockSorted)),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Recent transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            TransactionList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
