import 'package:flutter/material.dart';

import '../models/user.dart';

class SettingDetailScreen extends StatelessWidget {
  static const routeName = '/setting-detail';
  const SettingDetailScreen({required this.setting});

  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hey'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text('Editing ${setting.valueAsString()}'),
              ElevatedButton(
                  onPressed: () {
                    print(setting.valueAsString());
                  },
                  child: Text('Test'))
            ],
          ),
        ),
      ),
    );
  }
}
