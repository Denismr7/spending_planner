import 'package:flutter/material.dart';

import 'insight_card.dart';

class InsightsList extends StatelessWidget {
  const InsightsList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: ListView(
        children: [
          InsightCard(
            title: 'Month expenses',
            subtitle: 'Estimated expense: X \$',
            isExpandable: false,
          ),
          InsightCard(
            title: 'This year',
            subtitle: 'On average you have spent X \$ per month',
            isExpandable: true,
          ),
          InsightCard(
            title: 'Top categories',
            subtitle: 'Expenses',
            isExpandable: true,
          ),
        ],
      ),
    );
  }
}
