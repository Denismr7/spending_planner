import 'dart:convert';

import 'package:flutter/material.dart';

import 'edit_category_form.dart';
import 'setting_option.dart';
import '../models/category.dart';

class CategoriesEdit extends StatefulWidget {
  const CategoriesEdit(this.jsonData, {required this.onChange});

  final String jsonData;
  final Function(String edittedJson) onChange;

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

  void _showEditCategoryMBS(Category? selectedCategory) async {
    var catIndex = _categories
        .indexWhere((category) => category.id == selectedCategory?.id);
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditCategoryForm(initialValue: selectedCategory),
    ).then((value) {
      if (value == null) return;
      var updatedCategory = value as Map<String, dynamic>;

      // Remove category
      if (updatedCategory.isEmpty) {
        _categories.removeAt(catIndex);
      } else {
        if (selectedCategory != null) {
          _editCategory(selectedCategory, updatedCategory, catIndex);
        } else {
          _createCategory(updatedCategory);
        }
      }

      setState(() {});
      // Emit new JSON
      widget.onChange(jsonEncode(_categories));
    });
  }

  void _editCategory(Category selectedCategory, Map<String, dynamic> updatedCat,
      int catIndex) {
    _categories[catIndex] = Category(
      id: selectedCategory.id,
      name: updatedCat['name'],
      categoryType: Category.parseCategoryType(updatedCat['categoryType']),
    );
  }

  void _createCategory(Map<String, dynamic> data) {
    var lastIndex = int.parse(_categories.last.id) + 1;
    var category = Category(
      id: lastIndex.toString(),
      name: data['name'],
      categoryType: Category.parseCategoryType(data['categoryType']),
    );

    _categories.add(category);
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
              icon: Icons.category_rounded,
              simpleInput: false,
              initialValue: category,
              onChanged: (v) {},
              onTapDetail: () => _showEditCategoryMBS(category),
              detailIcon: Icons.edit_rounded,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ..._buildCategoryItems(_categories),
              ],
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () => _showEditCategoryMBS(null),
            child: const Text('Create'))
      ],
    );
  }
}
