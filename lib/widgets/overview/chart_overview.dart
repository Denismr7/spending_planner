import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../models/transaction.dart';
import '../../providers/user.dart';
import 'horizontal_budget_chart.dart';
import '../../models/user.dart';
import 'horizontal_budget_chart_title.dart';

class ChartOverview extends StatelessWidget {
  final List<Transaction> monthTransactions;
  const ChartOverview(this.monthTransactions);

  final double barChartHeight = 50;

  double getTotalSpending(List<Transaction> transactions) {
    var totalSpending = 0.0;
    for (var i = 0; i < transactions.length; i++) {
      var transaction = transactions[i];
      if (transaction.categoryType == CategoryType.Expenses) {
        totalSpending += transaction.amount;
      }
    }

    return totalSpending;
  }

  @override
  Widget build(BuildContext context) {
    final totalSpending = getTotalSpending(monthTransactions);
    final budget = Provider.of<UserProvider>(context, listen: true).getBudget();
    final currency = Provider.of<UserProvider>(context, listen: true)
        .getSettingValueAsString(Setting.Currency);
    final spentPercentage = totalSpending / budget.limit;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HorizontalBudgetChartTitle(
            totalSpending: totalSpending,
            budgetLimit: budget.limit,
            currency: currency,
          ),
          HorizontalBudgetChart(
            barChartHeight: barChartHeight,
            spentPercentage: spentPercentage,
            totalSpent: totalSpending,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              '${budget.limit.toStringAsFixed(2)} $currency',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
