import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'insight_card_growth_text.dart';
import 'insight_card_title.dart';
import '../../models/user.dart';
import '../../providers/user.dart';
import '../../models/bar_chart_insights_data.dart';
import 'bar_chart_card.dart';
import 'insight_card_subtitle.dart';

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
  String? _barDetailText;

  void _handleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  Widget _handleGrowthTextVisibility(
      String? barDetailText, String? growthText) {
    if (growthText == null) return const SizedBox();
    if (barDetailText != null) return const SizedBox(height: 22);

    return InsightCardGrowthText(
        growth: widget.growth!, growthText: widget.growthText!);
  }

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<UserProvider>(context, listen: false)
        .getSettingValueAsString(Setting.Currency);

    void _handleLongPress(String? label, double? value) {
      String? text;
      if (label == null || value == null) {
        // Clear detail text to show subtitle
        text = null;
      } else {
        text = '$label: ${value.toStringAsFixed(2)} $currency';
      }

      setState(() {
        _barDetailText = text;
      });
    }

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
                InsightCardTitle(
                  title: widget.title,
                  isExpandable: widget.isExpandable,
                  isExpanded: _expanded,
                  onTapExpand: _handleExpand,
                ),
                if (widget.subtitle != null || _barDetailText != null)
                  InsightCardSubtitle(text: _barDetailText ?? widget.subtitle!),
                _handleGrowthTextVisibility(_barDetailText, widget.growthText),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BarChartCard(
                data: widget.chartData,
                expanded: _expanded,
                onLongPress: _handleLongPress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
