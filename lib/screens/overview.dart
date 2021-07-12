import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/chart_overview.dart';
import '../mock.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = '/overview';
  const OverviewScreen();

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
            // TODO: Set transactions of the current month
            ChartOverview(transactionsMockSorted),
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
