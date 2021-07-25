import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    Key? key,
    required this.heightFactor,
    required this.label,
    required this.value,
    required this.vertical,
  }) : super(key: key);

  final double heightFactor;
  final String label;
  final double value;
  final bool vertical;

  Widget buildVerticalBar() {
    return Column(
      children: [
        Expanded(
          child: FractionallySizedBox(
            heightFactor: heightFactor,
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: null,
            ),
          ),
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
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FractionallySizedBox(
            widthFactor: heightFactor,
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value.toStringAsFixed(2) + " " + currency,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<UserProvider>(context, listen: false)
        .getSettingValue(Setting.Currency);
    return vertical ? buildVerticalBar() : buildHorizontalBar(currency);
  }
}
