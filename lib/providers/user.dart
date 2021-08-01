import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../helpers/transactions.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/user.dart';
import '../models/transaction.dart' as t;
import '../extensions.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  List<UserSettings> get userSettings =>
      _user?.settings == null ? [] : _user!.settings;

  void setUser(
      String id, String email, String name, List<UserSettings> settings) {
    _user = User(id: id, login: email, name: name, settings: settings);
  }

  dynamic getSettingValue(Setting key) {
    return _user?.settings.firstWhere((setting) => setting.key == key).value ??
        "";
  }

  String getSettingValueAsString(Setting key) {
    return getSettingValue(key).toString();
  }

  double getSettingValueAsDouble(Setting key) {
    return double.parse(getSettingValueAsString(key));
  }

  Budget getBudget() {
    var data = getSettingValue(Setting.Budget);
    return Budget.fromJson(jsonDecode(data));
  }

  Future<double> calculateBudgetLimit(int newPercentage) async {
    try {
      var user = auth.FirebaseAuth.instance;
      var currentDate = DateTime.now();

      var transactions = await TransactionsHelper.getTransactionsByMonth(
        user.currentUser!.uid,
        currentDate.month,
        currentDate.year,
      );
      var incomesAmount = 0.0;
      transactions.forEach((element) {
        if (element.categoryType == CategoryType.Incomes) {
          incomesAmount += element.amount;
        }
      });

      var budget = (incomesAmount * (newPercentage / 100)).toStringAsFixed(2);
      print('SPLAN.UserProvider() SmartBudget enabled, new budget $budget');
      return double.parse(budget);
    } catch (e) {
      print('SPLAN.UserProvider() Error $e');
      throw e;
    }
  }

  Future<void> updateBudgetLimit(t.Transaction transaction) async {
    if (transaction.categoryType == CategoryType.Expenses) return;
    var now = DateTime.now();

    if (transaction.date.year != now.year ||
        transaction.date.month != now.month) return;

    var budgetData = getBudget();
    if (budgetData.smartBudget == false) return;

    budgetData.limit = await calculateBudgetLimit(budgetData.percentage!);
    try {
      await updateSettingValue({Setting.Budget: jsonEncode(budgetData)});
      notifyListeners();
    } catch (e) {
      print('SPLAN.updateBudgetLimit() Error: ' + e.toString());
    }
  }

  Future<void> updateSettingValue(Map<Setting, dynamic> newSettings) async {
    try {
      var user = auth.FirebaseAuth.instance;
      if (user.currentUser == null) {
        print('SPLAN.UserProvider(): current user null');
        return;
      }

      Map<String, Object> mappedSettings = {};
      // Remove empty values
      newSettings.keys.forEach((key) {
        var value = newSettings[key];
        if (value == null) {
          newSettings.remove(key);
        }

        mappedSettings[key.valueAsString().toLowerCase()] = value;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .update(mappedSettings);

      newSettings.keys.forEach((key) {
        var settingIndex =
            _user?.settings.indexWhere((element) => element.key == key);
        if (settingIndex == null || settingIndex.isNaN) {
          print('SPLAN.UserProvider(): Setting $key not found');
          return;
        }

        print('Updated setting with key $key, value ${newSettings[key]}');
        var newValue = newSettings[key];
        var updatedSetting = UserSettings(key, newValue);
        _user?.settings[settingIndex] = updatedSetting;
      });
      notifyListeners();
    } catch (e) {
      print('SPLAN.UserProvider() Error $e');
      throw e;
    }
  }
}
