import 'package:flutter/material.dart';

class InsightCardTitle extends StatelessWidget {
  const InsightCardTitle({
    Key? key,
    required this.title,
    required this.isExpandable,
    required this.isExpanded,
    this.onTapExpand,
  }) : super(key: key);

  final String title;
  final bool isExpandable;
  final bool isExpanded;
  final VoidCallback? onTapExpand;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          GestureDetector(
            onTap: onTapExpand,
            child: Icon(
              isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
              size: 35,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
