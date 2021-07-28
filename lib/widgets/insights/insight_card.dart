import 'package:flutter/material.dart';

import '../../models/bar_chart_insights_data.dart';
import 'bar_chart_card.dart';

class InsightCard extends StatefulWidget {
  const InsightCard({
    Key? key,
    required this.title,
    required this.isExpandable,
    required this.chartData,
    this.subtitle,
    this.growth,
    this.growthText,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final double? growth;
  final String? growthText;
  final bool isExpandable;
  final List<BarChartInsightsData> chartData;

  @override
  _InsightCardState createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _expanded ? 400 : 240,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.isExpandable)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Icon(
                          _expanded ? Icons.arrow_drop_down : Icons.arrow_right,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                if (widget.subtitle != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (widget.growth != null)
                  Row(
                    children: [
                      Icon(
                        widget.growth! < 0
                            ? Icons.arrow_drop_down_rounded
                            : Icons.arrow_drop_up_rounded,
                        size: 22,
                        color: widget.growth! < 0 ? Colors.red : Colors.white,
                      ),
                      Text(
                        widget.growthText!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BarChartCard(
                data: widget.chartData,
                expanded: _expanded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
