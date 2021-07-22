import 'package:flutter/material.dart';

import 'overview.dart';
import 'settings.dart';
import '../widgets/action_button.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/insights_list.dart';

class InsightsScreen extends StatelessWidget {
  static const routeName = '/insights';
  const InsightsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: InsightsList(),
      floatingActionButton: ExpandableFab(
        distance: 90.0,
        initialOpen: false,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
          ActionButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(OverviewScreen.routeName);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
    );
  }
}
