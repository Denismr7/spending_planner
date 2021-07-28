import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../models/user.dart';
import '../../providers/user.dart';
import 'transaction_options_sheet.dart';

class TransactionItem extends StatelessWidget {
  final String description;
  final DateTime date;
  final CategoryType categoryType;
  final double amount;
  final String id;
  final VoidCallback onLongPress;

  TransactionItem({
    Key? key,
    required this.description,
    required this.date,
    required this.categoryType,
    required this.amount,
    required this.id,
    required this.onLongPress,
  }) : super(key: key);

  final expenseColor = Colors.red[700];

  @override
  Widget build(BuildContext context) {
    var isIncome = categoryType == CategoryType.Incomes ? true : false;
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
          builder: (ctx) => TransactionOptionsSheet(id),
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
      ),
    );
  }
}
