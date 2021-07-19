import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../widgets/categories_edit.dart';
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

  String _getCategories() {
    String categories = Provider.of<UserProvider>(context, listen: false)
        .getSettingValue(Setting.Categories);
    return categories;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    switch (widget.setting) {
      case Setting.Categories:
        _jsonData = _getCategories();
        break;
      default:
        _jsonData = "";
    }
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
