import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user.dart';
import '../widgets/setting_option.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsScreen();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<Setting, dynamic> _settings = {};
  var _loading = false;

  void _onChange(Setting settingName, String? value) {
    if (value == null || value.isEmpty) {
      // If the settings key exists but the value has been cleared, remove map entry
      if (_settings.containsKey(settingName)) {
        setState(() {
          _settings.remove(settingName);
        });
      }
      return;
    }
    setState(() {
      _settings[settingName] = value;
    });
  }

  void _onSave() async {
    setState(() {
      _loading = true;
    });

    _settings.keys.forEach((key) {
      var settingValue = _settings[key];
      if (settingValue == null) {
        _settings.remove(key);
      }
    });

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .updateSettingValue(_settings);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: _settings.isEmpty || _loading ? null : _onSave,
            icon: const Icon(
              Icons.save_rounded,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingOption(
              label: 'Budget',
              icon: Icons.bar_chart,
              simpleInput: true,
              initialValue: '300',
              inputType: TextInputType.number,
              onChanged: (val) {
                _onChange(Setting.Budget, val);
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
