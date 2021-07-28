import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/transactions.dart';
import '../../models/bar_chart_insights_data.dart';
import '../../models/category.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';
import '../../providers/user.dart';

import 'insight_card.dart';

class InsightsList extends StatefulWidget {
  const InsightsList();

  @override
  _InsightsListState createState() => _InsightsListState();
}

class _InsightsListState extends State<InsightsList> {
  // Chart data
  List<BarChartInsightsData> _currentMonthSpending = [];
  List<BarChartInsightsData> _yearSpending = [];
  List<BarChartInsightsData> _categoriesSpending = [];

  // Common data
  List<Transaction> _yearTransactions = [];
  var _currentDate = DateTime.now();

  // Variables displayed in charts
  double? _estimatedMonthExpense;
  double? _monthAverageExpense;
  double? _weekGrowth;
  String? _weekGrowthText;
  double? _monthGrowth;
  String? _monthGrowthText;

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
      var monthExpenses =
          yearExpenses.where((element) => element.date.month == i).toList();
      monthExpenses
          .forEach((element) => currentMonthExpenses += element.amount);

      // Current month charts data
      if (i == _currentDate.month) {
        _calculateMonthSpending(monthExpenses);
        _calculateTopCategories(monthExpenses);
        var prevMonthExpenses = 0.0;
        yearExpenses
            .where((element) => element.date.month == i - 1)
            .forEach((element) => prevMonthExpenses += element.amount);
        _calculateMonthGrowth(currentMonthExpenses, prevMonthExpenses);
      }

      // Create label with the first letter of the current month
      var currentMonthDate = DateTime(_currentDate.year, i);
      var monthName = DateFormat.MMMM().format(currentMonthDate);
      _yearSpending.add(
        BarChartInsightsData(
            label: monthName,
            value: currentMonthExpenses,
            isCurrentDate: i == _currentDate.month),
      );
    }

    // Get average
    int totalMonths = 0;
    double totalSpent = 0;
    _yearSpending.forEach((element) {
      if (element.value > 0) {
        totalMonths++;
        totalSpent += element.value;
      }
    });
    _monthAverageExpense = totalMonths > 0 ? totalSpent / totalMonths : 0;
  }

  void _calculateMonthGrowth(
    double currentMonthExpenses,
    double prevMonthExpenses,
  ) {
    if (prevMonthExpenses == 0) {
      print('Previous month expenses is 0. Skipping calculation');
      return;
    }
    double growth =
        ((currentMonthExpenses - prevMonthExpenses) / prevMonthExpenses) * 100;
    _monthGrowth = double.parse(growth.toStringAsFixed(2));
    String incrOrDecr = growth < 0 ? "less" : "more";
    _monthGrowthText = '$_monthGrowth% $incrOrDecr than prev. month';
  }

  void _calculateTopCategories(List<Transaction> monthTransactions) {
    // Get user expenses categories
    String json = Provider.of<UserProvider>(context, listen: false)
        .getSettingValueAsString(Setting.Categories);
    List<Category> categories = Category.parseJsonCategories(json)
        .where((element) => element.categoryType == CategoryType.Expenses)
        .toList();

    // Calculate data
    for (var i = 0; i < categories.length; i++) {
      var currentCategory = categories[i];
      double categoryAmount = 0;
      monthTransactions.forEach((element) {
        if (element.categoryId == currentCategory.id) {
          categoryAmount += element.amount;
        }
      });

      // Create chart data
      _categoriesSpending.add(BarChartInsightsData(
        label: currentCategory.name,
        value: categoryAmount,
      ));
    }

    _categoriesSpending.sort((a, b) => b.value.compareTo(a.value));
  }

  void _calculateMonthSpending(List<Transaction> monthTransactions) {
    Map<String, double> valuesInWeeks =
        _splitMonthInWeeksWithAmounts(monthTransactions);

    // Transform map and get estimated
    double monthTotal = 0;
    int lastWeekNumber = int.parse(valuesInWeeks.keys.last.substring(1));
    valuesInWeeks.forEach((key, value) {
      monthTotal += value;
      bool isCurrentWeek = _dateIsInCurrentWeek(
        _currentDate,
        int.parse(key.substring(1)),
        lastWeekNumber,
      );
      _currentMonthSpending.add(
        BarChartInsightsData(
          label: key,
          value: value,
          isCurrentDate: isCurrentWeek,
        ),
      );

      if (isCurrentWeek && key != "W1") {
        String prevWeekKey = "W" + (int.parse(key.substring(1)) - 1).toString();
        _calculateWeekGrowth(value, valuesInWeeks[prevWeekKey] ?? 0);
      }
    });
    _estimatedMonthExpense =
        valuesInWeeks.keys.length > 0 ? _calculateMonthEstimate(monthTotal) : 0;
  }

  void _calculateWeekGrowth(double currentWeek, double prevWeek) {
    if (prevWeek == 0) {
      print('Prev week = 0. Skipping calculation');
      return;
    }

    double growth = ((currentWeek - prevWeek) / prevWeek) * 100;
    _weekGrowth = double.parse(growth.toStringAsFixed(2));
    String incrOrDecr = growth < 0 ? "less" : "more";
    _weekGrowthText = '$_weekGrowth% $incrOrDecr than prev. week';
  }

  bool _dateIsInCurrentWeek(DateTime currentDate, int week, int totalWeeks) {
    int currentWeek = (_currentDate.day / 7).round();
    currentWeek = currentWeek > totalWeeks ? currentWeek-- : currentWeek;
    return currentWeek == week;
  }

  double _calculateMonthEstimate(double monthTotalExpenses) {
    double expensePerDay = monthTotalExpenses / _currentDate.day;
    int daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    return expensePerDay * daysInMonth;
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
      _calculateYearSpendingInMonths();

      // Reload widget once finished
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<UserProvider>(context, listen: false)
        .getSettingValueAsString(Setting.Currency);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: ListView(
        children: [
          InsightCard(
            title: 'Month expenses',
            subtitle:
                'Estimated expense: ${_estimatedMonthExpense?.toStringAsFixed(2)} $currency',
            isExpandable: false,
            chartData: _currentMonthSpending,
            growth: _weekGrowth,
            growthText: _weekGrowthText,
          ),
          InsightCard(
            title: 'This year',
            subtitle:
                'On average you have spent ${_monthAverageExpense?.toStringAsFixed(2)} $currency per month',
            isExpandable: true,
            chartData: _yearSpending,
            growth: _monthGrowth,
            growthText: _monthGrowthText,
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
