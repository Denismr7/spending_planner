import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'insights_screen.dart';
import 'settings.dart';
import '../widgets/common/action_button.dart';
import '../widgets/common/expandable_fab.dart';
import 'error.dart';
import 'loading.dart';
import '../widgets/overview/transaction_list.dart';
import '../widgets/overview/chart_overview.dart';
import '../models/transaction.dart';
import '../helpers/transactions.dart';
import '../widgets/overview/add_transaction.dart';

class OverviewScreen extends StatefulWidget {
  static const routeName = '/overview';
  const OverviewScreen();

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Transaction> _fetchedTransactions = [];

  List<Transaction> _filterByCurrentMonth(List<Transaction> transactions) {
    List<Transaction> currentMonthTransactions = [];
    var currentDate = DateTime.now();
    transactions.forEach((transaction) {
      if (transaction.date.month == currentDate.month &&
          transaction.date.year == currentDate.year) {
        currentMonthTransactions.add(transaction);
      }
    });
    return currentMonthTransactions;
  }

  Future<List<Transaction>> _getTransactions(String userId, int limit,
      [bool update = false]) async {
    final data = await TransactionsHelper.searchUserTransactions(
        userId: userId, limit: limit);
    _fetchedTransactions = data;
    if (update) {
      setState(() {});
    }
    return data;
  }

  void _showAddTransactionMBS(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: const Radius.circular(8),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return AddTransaction();
      },
    ).then((value) {
      Transaction? newTransaction = value;
      if (newTransaction == null) return;

      setState(() {
        _fetchedTransactions.add(newTransaction);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
            future: _getTransactions(user.currentUser!.uid, 30),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingScreen();
              } else if (snap.hasError) {
                return ErrorScreen(snap.error.toString());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChartOverview(_filterByCurrentMonth(_fetchedTransactions)),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Recent transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  // TODO: View transactions by categories
                  TransactionList(
                    _fetchedTransactions,
                    () => _getTransactions(user.currentUser!.uid, 30, true),
                  )
                ],
              );
            }),
      ),
      floatingActionButton: ExpandableFab(
        distance: 90.0,
        initialOpen: false,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
          ActionButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(InsightsScreen.routeName);
            },
            icon: const Icon(Icons.bar_chart_rounded),
          ),
          ActionButton(
            onPressed: () => _showAddTransactionMBS(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
