import 'package:flutter/material.dart';

import '../mock.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) => TransactionItem(
          description: transactionsMockSorted[index].description,
          date: transactionsMockSorted[index].date,
          categoryType: transactionsMockSorted[index].categoryType,
          amount: transactionsMockSorted[index].amount,
        ),
        itemCount: transactionsMockSorted.length,
      ),
    );
  }
}
