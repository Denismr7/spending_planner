import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spending_planner/models/budget.dart';
import 'package:spending_planner/widgets/settings/setting_option.dart';

// TODO: Save data (TEST)
// TODO: Update budget when adding new income transaction if smartBudget is enabled

class BudgetEdit extends StatefulWidget {
  const BudgetEdit(this.jsonData, {required this.onChange});

  final String jsonData;
  final Function(String edittedJson) onChange;

  @override
  _BudgetEditState createState() => _BudgetEditState();
}

class _BudgetEditState extends State<BudgetEdit> {
  Budget? _budgetData;

  @override
  void initState() {
    super.initState();
    _budgetData = Budget.fromJson(jsonDecode(widget.jsonData));
  }

  void _onChange(String fieldName, dynamic newValue) {
    if (newValue == null) return;

    switch (fieldName) {
      case 'smartBudget':
        setState(() {
          _budgetData?.smartBudget = newValue;
        });
        break;
      case 'limit':
        _budgetData?.limit = double.parse(newValue);
        break;
      case 'percentage':
        _budgetData?.percentage = int.parse(newValue);
        break;
      default:
        break;
    }

    // Emit new JSON
    widget.onChange(jsonEncode(_budgetData));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights_rounded,
                  size: 35,
                  color: Theme.of(context).accentColor,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart Budget',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      'Set a percentage of your income as a budget',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Switch(
              value: _budgetData!.smartBudget,
              onChanged: (v) => _onChange('smartBudget', v),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (_budgetData!.smartBudget)
          SettingOption(
            key: UniqueKey(),
            label: 'Percentage',
            icon: Icons.calculate_rounded,
            simpleInput: true,
            initialValue: _budgetData?.percentage ?? 0,
            onChanged: (v) => _onChange('percentage', v),
          ),
        if (!_budgetData!.smartBudget)
          SettingOption(
            key: UniqueKey(),
            label: 'Budget',
            icon: Icons.price_change_rounded,
            simpleInput: true,
            initialValue: _budgetData?.limit ?? 0,
            onChanged: (v) => _onChange('limit', v),
          )
      ],
    );
  }
}
