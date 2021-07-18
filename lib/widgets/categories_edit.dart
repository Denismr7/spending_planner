import 'dart:convert';

import 'package:flutter/material.dart';

import 'setting_option.dart';
import '../models/category.dart';

class CategoriesEdit extends StatefulWidget {
  const CategoriesEdit(this.jsonData);

  final String jsonData;

  @override
  _CategoriesEditState createState() => _CategoriesEditState();
}

class _CategoriesEditState extends State<CategoriesEdit> {
  List<Category> _categories = [];

  List<Category> _parseJsonData(String jsonData) {
    List<Category> parsedList = [];
    List<dynamic> parsedJson = jsonDecode(jsonData);
    parsedJson.forEach((element) {
      parsedList.add(Category.fromJson(element));
    });

    return parsedList;
  }

  @override
  void initState() {
    super.initState();
    _categories = _parseJsonData(widget.jsonData);
  }

  List<Widget> _buildCategoryItems(List<Category> items) {
    return items
        .map((category) => SettingOption(
              label: category.name,
              icon: Icons.ac_unit_rounded,
              simpleInput: false,
              initialValue: category,
              onChanged: (v) {},
              onTapDetail: () {},
              detailIcon: Icons.more_horiz,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildCategoryItems(_categories),
    );
  }
}
