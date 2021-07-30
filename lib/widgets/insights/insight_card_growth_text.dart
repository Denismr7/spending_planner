import 'package:flutter/material.dart';

class InsightCardGrowthText extends StatelessWidget {
  const InsightCardGrowthText({
    Key? key,
    required this.growth,
    required this.growthText,
  }) : super(key: key);

  final double growth;
  final String growthText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          growth < 0
              ? Icons.arrow_drop_down_rounded
              : Icons.arrow_drop_up_rounded,
          size: 22,
          color: growth < 0 ? Colors.red : Colors.white,
        ),
        Text(
          growthText,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ],
    );
    ;
  }
}
