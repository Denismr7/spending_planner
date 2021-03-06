import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/budget.dart';
import '../../models/user.dart';
import '../../providers/user.dart';
import 'setting_option.dart';

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
    String currency = Provider.of<UserProvider>(context)
        .getSettingValueAsString(Setting.Currency);
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
                        fontSize: 10,
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
            unit: "%",
            inputType: TextInputType.number,
          ),
        if (!_budgetData!.smartBudget)
          SettingOption(
            key: UniqueKey(),
            label: 'Budget',
            icon: Icons.price_change_rounded,
            simpleInput: true,
            initialValue: _budgetData?.limit ?? 0,
            onChanged: (v) => _onChange('limit', v),
            unit: currency,
            inputType: TextInputType.numberWithOptions(decimal: true),
          )
      ],
    );
  }
}
