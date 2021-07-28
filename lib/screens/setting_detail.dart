import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_planner/widgets/settings/budget_edit.dart';

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
          onChange: _onChangeCategories,
        );
      case Setting.Budget:
        return BudgetEdit(
          _jsonData!,
          onChange: (v) {},
        );
      default:
        return const Text('Invalid setting');
    }
  }

  void _onChangeCategories(String newJson) {
    _jsonData = newJson;
  }

  void _onSave() {
    Provider.of<UserProvider>(context, listen: false)
        .updateSettingValue({Setting.Categories: _jsonData});
    Navigator.of(context).pop(_jsonData);
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
            onPressed: _onSave,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _buildEditor(),
      ),
    );
  }
}
