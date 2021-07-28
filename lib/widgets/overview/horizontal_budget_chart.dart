import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user.dart';

class HorizontalBudgetChart extends StatelessWidget {
  const HorizontalBudgetChart({
    required this.barChartHeight,
    required this.spentPercentage,
    required this.totalSpent,
  });

  final double barChartHeight;
  final double spentPercentage;
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<UserProvider>(context, listen: false)
        .getSettingValue(Setting.Currency);
    return Stack(
      children: [
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            height: barChartHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10),
              ),
              color: Colors.black26,
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: spentPercentage < 1 ? spentPercentage : 1,
          child: Container(
              height: barChartHeight,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
                color: Theme.of(context).accentColor,
              ),
              child: LayoutBuilder(
                builder: (ctx, constraint) {
                  if (constraint.maxWidth > 50) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${totalSpent.toStringAsFixed(2)} $currency',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )),
        ),
      ],
    );
  }
}
