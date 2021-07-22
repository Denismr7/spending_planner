import 'package:flutter/material.dart';
import 'package:spending_planner/models/bar_chart_insights_data.dart';
import 'package:spending_planner/widgets/bar_chart_card.dart';

List<BarChartInsightsData> mockData = [
  BarChartInsightsData(label: 'L', value: 30),
  BarChartInsightsData(label: 'M', value: 10),
  BarChartInsightsData(label: 'X', value: 40),
  BarChartInsightsData(label: 'J', value: 10),
  BarChartInsightsData(label: 'V', value: 25),
  BarChartInsightsData(label: 'S', value: 40),
  BarChartInsightsData(label: 'D', value: 40),
];

class InsightCard extends StatelessWidget {
  const InsightCard({
    Key? key,
    required this.title,
    required this.isExpandable,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final bool isExpandable;
  // TODO: Include chart-related data

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10),
        ),
        color: Theme.of(context).cardColor,
      ),
      margin: const EdgeInsets.only(bottom: 40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (isExpandable)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_right,
                      size: 35,
                    ),
                    color: Colors.white,
                  ),
              ],
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            Container(
                width: double.infinity, child: BarChartCard(data: mockData)),
          ],
        ),
      ),
    );
  }
}
