import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/transactions.dart';
import '../models/bar_chart_insights_data.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../providers/user.dart';

import 'insight_card.dart';

class InsightsList extends StatefulWidget {
  const InsightsList();

  @override
  _InsightsListState createState() => _InsightsListState();
}

class _InsightsListState extends State<InsightsList> {
  List<BarChartInsightsData> _currentMonthSpending = [];
  List<BarChartInsightsData> _yearSpending = [];
  List<BarChartInsightsData> _categoriesSpending = [];
  List<Transaction> _yearTransactions = [];
  var _currentDate = DateTime.now();

  Future<void> _fetchYearTransactions() async {
    var user = FirebaseAuth.instance;
    var transactions = await TransactionsHelper.searchUserTransactions(
      userId: user.currentUser!.uid,
      from: DateTime(_currentDate.year),
      to: _currentDate,
    );

    _yearTransactions = transactions.reversed.toList();
  }

  void _calculateYearSpendingInMonths() {
    var yearExpenses = _yearTransactions
        .where((element) => element.categoryType == CategoryType.Expenses);

    for (var i = 1; i <= DateTime.monthsPerYear; i++) {
      // Calculate expenses current month
      double currentMonthExpenses = 0;
      yearExpenses
          .where((element) => element.date.month == i)
          .forEach((element) => currentMonthExpenses += element.amount);

      // Create label with the first letter of the current month
      var currentMonthDate = DateTime(_currentDate.year, i);
      var firstLetterMonth =
          DateFormat.MMMM().format(currentMonthDate).substring(0, 1);
      _yearSpending.add(
        BarChartInsightsData(
            label: firstLetterMonth, value: currentMonthExpenses),
      );
    }
  }

  void _calculateTopCategories() {
    // Get user categories
    String json = Provider.of<UserProvider>(context, listen: false)
        .getSettingValue(Setting.Categories);
    List<Category> categories = Category.parseJsonCategories(json);

    // Get current month transactions
    var monthTransactions = _yearTransactions
        .where((element) =>
            element.date.month == _currentDate.month &&
            element.categoryType == CategoryType.Expenses)
        .toList();

    // Calculate data
    for (var i = 0; i < categories.length; i++) {
      var currentCategory = categories[i];
      var categoryLabel = currentCategory.name.substring(0, 2);
      double categoryAmount = 0;
      monthTransactions.forEach((element) {
        if (element.categoryId == currentCategory.id) {
          categoryAmount += element.amount;
        }
      });

      // Create chart data
      _categoriesSpending.add(
          BarChartInsightsData(label: categoryLabel, value: categoryAmount));
    }
  }

  void _calculateMonthSpending() {
    var monthTransactions = _yearTransactions
        .where((element) =>
            element.date.month == _currentDate.month &&
            element.categoryType == CategoryType.Expenses)
        .toList();
    Map<String, double> valuesInWeeks =
        _splitMonthInWeeksWithAmounts(monthTransactions);

    // Transform map
    valuesInWeeks.forEach((key, value) {
      _currentMonthSpending.add(BarChartInsightsData(label: key, value: value));
    });
  }

  Map<String, double> _splitMonthInWeeksWithAmounts(
      List<Transaction> monthTransactions) {
    // Initialize values
    Map<String, double> valuesInWeeks = {};
    var weekNumber = 1;
    double weekValue = 0;
    var weekStartsAt = DateTime(_currentDate.year, _currentDate.month).weekday;

    // Loop through all days of the month
    for (DateTime indexDay = DateTime(_currentDate.year, _currentDate.month, 1);
        indexDay.month == _currentDate.month;
        indexDay = indexDay.add(Duration(days: 1))) {
      if (indexDay.weekday == weekStartsAt && indexDay.day > 1) {
        // Save previous week
        print('Saving week W$weekNumber with value $weekValue');
        valuesInWeeks['W$weekNumber'] = weekValue;

        // Start a new week
        weekNumber++;
        weekValue = 0;

        // Find transactions in the current day and sum the amount to the current week
        monthTransactions
            .where((element) => element.date.day == indexDay.day)
            .forEach((element) => weekValue += element.amount);
      } else {
        // Find transactions in the current day and sum the amount to the current week
        monthTransactions
            .where((element) => element.date.day == indexDay.day)
            .forEach((element) => weekValue += element.amount);
      }
    }
    // Month remaining days goes to the last week created
    if (!valuesInWeeks.containsKey('W$weekNumber')) {
      weekNumber--;
      print('Adding $weekValue \$ to the previous week W$weekNumber');
      valuesInWeeks['W$weekNumber'] =
          valuesInWeeks['W$weekNumber'] ?? 0 + weekValue;
    }

    // Return completed map
    return valuesInWeeks;
  }

  @override
  void initState() {
    super.initState();
    _fetchYearTransactions().then((_) {
      _calculateMonthSpending();
      _calculateYearSpendingInMonths();
      _calculateTopCategories();

      // Reload widget once finished
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: ListView(
        children: [
          InsightCard(
            title: 'Month expenses',
            subtitle: 'Estimated expense: X \$',
            isExpandable: false,
            chartData: _currentMonthSpending,
          ),
          InsightCard(
            title: 'This year',
            subtitle: 'On average you have spent X \$ per month',
            isExpandable: true,
            chartData: _yearSpending,
          ),
          InsightCard(
            title: 'Top categories',
            subtitle: 'By expenses this month',
            isExpandable: true,
            chartData: _categoriesSpending,
          ),
        ],
      ),
    );
  }
}
