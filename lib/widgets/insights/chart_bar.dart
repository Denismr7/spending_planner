import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    Key? key,
    required this.heightFactor,
    required this.label,
    required this.value,
    required this.vertical,
    this.isCurrentDate = false,
  }) : super(key: key);

  final double heightFactor;
  final String label;
  final double value;
  final bool vertical;
  final bool isCurrentDate;

  String truncateLabelIfRequired(String label, int maxLength) {
    return label.length > maxLength
        ? '${label.substring(0, maxLength)}...'
        : label;
  }

  Widget buildVerticalBar() {
    return Column(
      children: [
        Bar(
          heightFactor: heightFactor,
          isCurrentDate: isCurrentDate,
          isVertical: true,
        ),
        Text(
          label.substring(0, 2),
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget buildHorizontalBar(String currency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomLeft,
              child: Text(
                truncateLabelIfRequired(label, 13),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Bar(
            heightFactor: heightFactor,
            isCurrentDate: isCurrentDate,
            isVertical: false,
          ),
          const SizedBox(width: 10),
          Text(
            value.toStringAsFixed(2) + " " + currency,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<UserProvider>(context, listen: false)
        .getSettingValueAsString(Setting.Currency);
    return vertical ? buildVerticalBar() : buildHorizontalBar(currency);
  }
}

class Bar extends StatelessWidget {
  const Bar({
    Key? key,
    required this.heightFactor,
    required this.isCurrentDate,
    required this.isVertical,
  }) : super(key: key);

  final double heightFactor;
  final bool isCurrentDate;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: isVertical ? heightFactor : null,
        widthFactor: !isVertical ? heightFactor : null,
        alignment: Alignment.bottomLeft,
        child: Container(
          width: isVertical ? 15 : null,
          height: !isVertical ? 20 : null,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              const Radius.circular(40),
            ),
            color: isCurrentDate ? Colors.white38 : Colors.white,
            border: isCurrentDate ? Border.all(color: Colors.white) : null,
          ),
          child: null,
        ),
      ),
    );
  }
}
