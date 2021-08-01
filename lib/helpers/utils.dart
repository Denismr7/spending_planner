import 'package:firebase_auth/firebase_auth.dart';
import 'package:spending_planner/helpers/transactions.dart';

class UtilsHelper {
  static Future<double> calculateMonthEstimate(
    DateTime currentDate,
    double currentMonthExpenses,
  ) async {
    double estimate;
    switch (currentDate.day > 9) {
      case true:
        estimate = UtilsHelper._calculateUsingCurrentMonthData(
            currentDate, currentMonthExpenses);
        break;
      default:
        estimate = await UtilsHelper._calculateUsingPrevMonthData(
          currentDate,
          currentMonthExpenses,
        );
        break;
    }

    return estimate;
  }

  static double _calculateUsingCurrentMonthData(
    DateTime currentDate,
    double monthTotalExpenses,
  ) {
    double expensePerDay = monthTotalExpenses / currentDate.day;
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    return expensePerDay * daysInMonth;
  }

  static Future<double> _calculateUsingPrevMonthData(
    DateTime currentDate,
    double currentMonthTotalExpenses,
  ) async {
    // Get data
    var user = FirebaseAuth.instance;
    var prevMonth = DateTime(currentDate.year, currentDate.month, 0);
    var prevMonthTotalExpenses = await TransactionsHelper.getExpensesByMonth(
        user.currentUser!.uid, prevMonth.year, prevMonth.month);

    // Calculate
    var totalExpense = prevMonthTotalExpenses + currentMonthTotalExpenses;
    var totalDays = prevMonth.day + currentDate.day;
    var dailyAverage = totalExpense / totalDays;
    var totalDaysInCurrentMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0).day;
    var estimate = (dailyAverage * totalDaysInCurrentMonth).toStringAsFixed(2);
    return double.parse(estimate);
  }
}
