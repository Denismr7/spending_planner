import 'package:flutter/material.dart';

import 'screens/overview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spending Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverviewScreen(),
      routes: {
        OverviewScreen.routeName: (ctx) => OverviewScreen(),
      },
    );
  }
}
