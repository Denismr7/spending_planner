import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen(this.error);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text(error),
      ),
    );
  }
}
