import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Planner'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
