import 'package:flutter/material.dart';
import 'package:spending_planner/models/transaction.dart';

import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactions, this.onLongPressItem);

  final List<Transaction> transactions;
  final VoidCallback onLongPressItem;

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
                id: transactions[index].id,
                onLongPress: onLongPressItem,
              ),
              itemCount: transactions.length,
            ),
    );
  }
}
