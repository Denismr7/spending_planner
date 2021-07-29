import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/budget.dart';
import '../widgets/settings/budget_edit.dart';
import '../providers/user.dart';
import '../widgets/settings/categories_edit.dart';
import '../models/user.dart';

class SettingDetailScreen extends StatefulWidget {
  static const routeName = '/setting-detail';
  const SettingDetailScreen({required this.setting});

  final Setting setting;

  @override
  _SettingDetailScreenState createState() => _SettingDetailScreenState();
}

class _SettingDetailScreenState extends State<SettingDetailScreen> {
  String? _jsonData;

  Widget _buildEditor() {
    switch (widget.setting) {
      case Setting.Categories:
        return CategoriesEdit(
          _jsonData!,
          onChange: _onChangeJson,
        );
      case Setting.Budget:
        return BudgetEdit(
          _jsonData!,
          onChange: _onChangeJson,
        );
      default:
        return const Text('Invalid setting');
    }
  }

  void _onChangeJson(String newJson) {
    _jsonData = newJson;
  }

  Future<void> _onSave(Setting setting) async {
    if (setting == Setting.Budget) {
      await _onSaveBudget(_jsonData!);
    }

    Provider.of<UserProvider>(context, listen: false)
        .updateSettingValue({setting: _jsonData});
    Navigator.of(context).pop(_jsonData);
  }

  Future<void> _onSaveBudget(String jsonData) async {
    Budget newBudget = Budget.fromJson(jsonDecode(jsonData));
    if (newBudget.smartBudget == false) return;

    var newLimit = await Provider.of<UserProvider>(context, listen: false)
        .calculateBudgetLimit(newBudget.percentage!);
    newBudget.limit = newLimit;

    _jsonData = jsonEncode(newBudget);
  }

  String _getJsonData(Setting setting) {
    String jsonData = Provider.of<UserProvider>(context, listen: false)
        .getSettingValueAsString(setting);
    return jsonData;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jsonData = _getJsonData(widget.setting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.setting.valueAsString(),
        ),
        actions: [
          IconButton(
            onPressed: () => _onSave(widget.setting),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _buildEditor(),
      ),
    );
  }
}
