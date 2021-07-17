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
  Map<Setting, dynamic> _editedSettings = {};
  Map<Setting, dynamic> _userSettings = {};
  var _loading = false;

  void _onChange(Setting settingName, String? value) {
    // Set state when setting change is required because the Save button will be disabled if de map is empty
    if (value == null || value.isEmpty) {
      // If the settings key exists but the value has been cleared or it's invalid, remove map entry
      if (_editedSettings.containsKey(settingName)) {
        setState(() {
          _editedSettings.remove(settingName);
        });
      }
      return;
    }
    setState(() {
      _editedSettings[settingName] = value;
    });
  }

  void _onSave() async {
    setState(() {
      _loading = true;
    });

    // Remove empty entries, if any
    _editedSettings.keys.forEach((key) {
      var settingValue = _editedSettings[key];
      if (settingValue == null) {
        _editedSettings.remove(key);
      }
    });

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .updateSettingValue(_editedSettings);
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Settings saved successfully')),
      );
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
    var userSettings =
        Provider.of<UserProvider>(context, listen: false).userSettings;
    userSettings.forEach((setting) {
      _userSettings[setting.key] = setting.value;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: _editedSettings.isEmpty || _loading ? null : _onSave,
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
              icon: Icons.warning_amber_rounded,
              simpleInput: true,
              initialValue: _userSettings[Setting.Budget],
              inputType: TextInputType.number,
              setting: Setting.Budget,
              onChanged: (val) {
                _onChange(Setting.Budget, val);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SettingOption(
              label: 'Currency',
              setting: Setting.Currency,
              icon: Icons.attach_money_rounded,
              simpleInput: true,
              initialValue: _userSettings[Setting.Currency],
              inputType: TextInputType.text,
              onChanged: (val) {
                _onChange(Setting.Currency, val);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SettingOption(
              label: 'Categories',
              icon: Icons.category_rounded,
              simpleInput: false,
              onChanged: (v) {},
              initialValue: _userSettings[Setting.Categories],
              setting: Setting.Categories,
            )
          ],
        ),
      ),
    );
  }
}
