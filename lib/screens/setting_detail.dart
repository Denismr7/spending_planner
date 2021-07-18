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
        return CategoriesEdit(_jsonData!);
      default:
        return const Text('Invalid setting');
    }
  }

  String _getCategories() {
    String categories =
        Provider.of<UserProvider>(context).getSettingValue(Setting.Categories);
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
        title: Text(widget.setting.valueAsString()),
      ),
      body: _buildEditor(),
    );
  }
}
