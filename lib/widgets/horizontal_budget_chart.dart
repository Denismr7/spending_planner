import 'package:flutter/material.dart';

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
                          '${totalSpent.toStringAsFixed(2)} \$',
                          textAlign: TextAlign.center,
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
