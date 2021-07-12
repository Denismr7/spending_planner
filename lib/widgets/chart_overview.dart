import 'package:flutter/material.dart';
import 'package:spending_planner/models/category.dart';
import 'package:spending_planner/models/transaction.dart';

import 'horizontal_budget_chart.dart';

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

    print(totalSpending);
    return totalSpending;
  }

  @override
  Widget build(BuildContext context) {
    final totalSpending = getTotalSpending(monthTransactions);
    // TODO: Get max spending amount and currency from user settings
    final limit = 250;
    final spentPercentage = totalSpending / limit;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Text(
              'Month overview',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
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
              '$limit \$',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
