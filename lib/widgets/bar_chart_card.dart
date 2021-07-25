import 'package:flutter/material.dart';

import '../models/bar_chart_insights_data.dart';
import 'chart_bar.dart';

class BarChartCard extends StatelessWidget {
  const BarChartCard({
    Key? key,
    required this.data,
    required this.expanded,
  }) : super(key: key);

  final List<BarChartInsightsData> data;
  final bool expanded;

  double calculateHeightFactor(double currentValue) {
    if (currentValue == 0) return currentValue;

    // Get max value
    var sortedData = [...data];
    sortedData.sort((a, b) => a.value.compareTo(b.value));
    var maxValue = sortedData.last.value;

    var heightFactor = currentValue / maxValue;
    return double.parse(heightFactor.toStringAsFixed(2));
  }

  List<Widget> _buildChartBars(bool isExpanded) {
    List<Widget> bars = [];
    data.forEach((e) {
      var heightFactor = calculateHeightFactor(e.value);
      if (!isExpanded) {
        bars.add(ChartBar(
          heightFactor: heightFactor,
          label: e.label,
          value: e.value,
          vertical: true,
        ));
      } else {
        bars.add(ChartBar(
          heightFactor: heightFactor,
          label: e.label,
          value: e.value,
          vertical: false,
        ));
      }
    });
    return bars;
  }

  Widget _buildHorizontalChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _buildChartBars(false),
    );
  }

  Widget _buildExpandedChart() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _buildChartBars(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return expanded ? _buildExpandedChart() : _buildHorizontalChart();
  }
}
