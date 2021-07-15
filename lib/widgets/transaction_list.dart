import 'package:flutter/material.dart';
import 'package:spending_planner/models/transaction.dart';

import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactions);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: transactions.length == 0
          ? Center(
              child: Text('No transactions yet!'),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) => TransactionItem(
                description: transactions[index].description,
                date: transactions[index].date,
                categoryType: transactions[index].categoryType,
                amount: transactions[index].amount,
              ),
              itemCount: transactions.length,
            ),
    );
  }
}
