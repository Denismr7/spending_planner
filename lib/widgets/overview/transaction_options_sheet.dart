import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction.dart';
import '../../providers/user.dart';
import '../../helpers/transactions.dart';
import '../common/icon_option.dart';

class TransactionOptionsSheet extends StatefulWidget {
  const TransactionOptionsSheet(this.transaction);

  final Transaction transaction;

  @override
  _TransactionOptionsSheetState createState() =>
      _TransactionOptionsSheetState();
}

class _TransactionOptionsSheetState extends State<TransactionOptionsSheet> {
  var _loading = false;

  Future<void> _deleteTransaction() async {
    setState(() {
      _loading = true;
    });

    try {
      await TransactionsHelper.deleteTransaction(widget.transaction.id);
      Provider.of<UserProvider>(context, listen: false)
          .updateBudgetLimit(widget.transaction, false);
    } catch (e) {}
    setState(() {
      _loading = false;
    });
    Navigator.of(context).pop(widget.transaction.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconOption(
              icon: Icon(
                Icons.delete,
                color: _loading ? Colors.black45 : Colors.red,
                size: 30,
              ),
              text: 'Delete transaction',
              onPressed: _loading ? null : _deleteTransaction,
            )
          ],
        ),
      ),
    );
  }
}
