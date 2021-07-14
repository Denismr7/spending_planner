import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/user.dart';
import '../providers/user.dart';

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
    final currency =
        Provider.of<UserProvider>(context).getSettingValue(Setting.Currency);
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(DateFormat.MMMMEEEEd().format(date)),
      trailing: Text(
        '$symbol ${amount.toStringAsFixed(2)} $currency',
        style: TextStyle(
          color: isIncome ? Colors.green[800] : expenseColor,
        ),
      ),
    );
  }
}
