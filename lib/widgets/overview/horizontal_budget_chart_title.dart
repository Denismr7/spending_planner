import 'package:flutter/material.dart';

class HorizontalBudgetChartTitle extends StatelessWidget {
  const HorizontalBudgetChartTitle({
    Key? key,
    required this.totalSpending,
    required this.budgetLimit,
    required this.currency,
  }) : super(key: key);

  final double totalSpending;
  final double budgetLimit;
  final String currency;

  double getRemainingBudget(double totalSpending, double budgetLimit) {
    var difference = budgetLimit - totalSpending;
    return difference > 0 ? difference : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remaining budget:',
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            getRemainingBudget(totalSpending, budgetLimit).toStringAsFixed(2) +
                ' $currency',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }
}
