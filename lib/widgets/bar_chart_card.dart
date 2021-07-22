import 'package:flutter/material.dart';
import 'package:spending_planner/models/bar_chart_insights_data.dart';
import 'package:spending_planner/widgets/bar_insight_card.dart';

class BarChartCard extends StatelessWidget {
  const BarChartCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<BarChartInsightsData> data;

  double calculateHeightFactor(double currentValue) {
    if (currentValue == 0) return currentValue;

    // Get max value
    var sortedData = [...data];
    sortedData.sort((a, b) => a.value.compareTo(b.value));
    var maxValue = sortedData.last.value;

    var heightFactor = currentValue / maxValue;
    return double.parse(heightFactor.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...data
              .map(
                (e) => BarInsightCard(
                    heightFactor: calculateHeightFactor(e.value),
                    label: e.label),
              )
              .toList()
        ],
      ),
    );
  }
}
