import 'package:flutter/material.dart';

class BarInsightCard extends StatelessWidget {
  const BarInsightCard({
    Key? key,
    required this.heightFactor,
    required this.label,
  }) : super(key: key);

  final double heightFactor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Column(
        children: [
          Expanded(
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
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
