import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/transaction.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../../providers/user.dart';
import 'transaction_options_sheet.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onLongPress;

  TransactionItem({
    Key? key,
    required this.transaction,
    required this.onLongPress,
  }) : super(key: key);

  final expenseColor = Colors.red[700];

  @override
  Widget build(BuildContext context) {
    var isIncome =
        transaction.categoryType == CategoryType.Incomes ? true : false;
    var symbol = isIncome ? "+" : "-";
    final currency = Provider.of<UserProvider>(context)
        .getSettingValueAsString(Setting.Currency);
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(
              top: const Radius.circular(8),
            ),
          ),
          context: context,
          builder: (ctx) => TransactionOptionsSheet(transaction),
        ).then((value) {
          if (value == null) return;
          onLongPress();
        });
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green[500] : expenseColor,
          child: Icon(
            isIncome ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          transaction.description,
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Text(
          DateFormat.MMMMEEEEd().format(transaction.date),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: Text(
          '$symbol ${transaction.amount.toStringAsFixed(2)} $currency',
          style: TextStyle(
            color: isIncome ? Colors.white : expenseColor,
          ),
        ),
      ),
    );
  }
}
