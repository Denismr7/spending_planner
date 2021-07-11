import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spending_planner/models/category.dart';

class TransactionItem extends StatelessWidget {
  final String description;
  final DateTime date;
  final CategoryType categoryType;
  final double amount;

  TransactionItem({
    Key? key,
    required this.description,
    required this.date,
    required this.categoryType,
    required this.amount,
  }) : super(key: key);

  final expenseColor = Colors.red[700];

  @override
  Widget build(BuildContext context) {
    var isIncome = categoryType == CategoryType.Incomes ? true : false;
    var symbol = isIncome ? "+" : "-";
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome ? Colors.green[500] : expenseColor,
        child: Icon(
          isIncome ? Icons.arrow_forward : Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: Text(
        description,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(DateFormat.MMMMEEEEd().format(date)),
      trailing: Text(
        // TODO: Replace dollar symbol with user setting value for currency
        '$symbol ${amount.toStringAsFixed(2)} \$',
        style: TextStyle(
          color: isIncome ? Colors.green[800] : expenseColor,
        ),
      ),
    );
  }
}
