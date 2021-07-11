import 'models/transaction.dart';
import 'models/category.dart';

var transactionsMock = [
  Transaction(
    id: "1",
    userId: "1",
    date: DateTime.now(),
    categoryId: "1",
    categoryType: CategoryType.Incomes,
    amount: 250.00,
    description: 'July Salary',
  ),
  Transaction(
    id: "2",
    userId: "1",
    date: DateTime.now().subtract(Duration(days: 1)),
    categoryId: "2",
    categoryType: CategoryType.Expenses,
    amount: 150.00,
    description: 'Grocery store',
  ),
  Transaction(
    id: "3",
    userId: "1",
    date: DateTime.now().subtract(Duration(days: 3)),
    categoryId: "3",
    categoryType: CategoryType.Incomes,
    amount: 250.00,
    description: 'Received transfer',
  ),
  Transaction(
    id: "4",
    userId: "1",
    date: DateTime.now().subtract(Duration(days: 8)),
    categoryId: "4",
    categoryType: CategoryType.Expenses,
    amount: 15.99,
    description: 'Netflix',
  ),
  Transaction(
    id: "5",
    userId: "1",
    date: DateTime.now(),
    categoryId: "1",
    categoryType: CategoryType.Incomes,
    amount: 250.00,
    description: 'July Salary',
  ),
  Transaction(
    id: "6",
    userId: "1",
    date: DateTime.now().subtract(Duration(days: 1)),
    categoryId: "2",
    categoryType: CategoryType.Expenses,
    amount: 150.00,
    description: 'Grocery store',
  ),
  Transaction(
    id: "7",
    userId: "1",
    date: DateTime.now().subtract(Duration(days: 3)),
    categoryId: "3",
    categoryType: CategoryType.Incomes,
    amount: 250.00,
    description: 'Received transfer',
  ),
  Transaction(
    id: "8",
    userId: "1",
    date: DateTime.now().subtract(Duration(days: 8)),
    categoryId: "4",
    categoryType: CategoryType.Expenses,
    amount: 15.99,
    description: 'Netflix',
  ),
]..sort((a, b) => b.date.compareTo(a.date));

var transactionsMockSorted = transactionsMock;

var categoriesMock = [
  Category(
    id: "1",
    name: "Salary",
    userId: "1",
    categoryType: CategoryType.Incomes,
  ),
  Category(
    id: "2",
    name: "Shops",
    userId: "1",
    categoryType: CategoryType.Expenses,
  ),
  Category(
    id: "3",
    name: "Transfers",
    userId: "1",
    categoryType: CategoryType.Incomes,
  ),
  Category(
    id: "4",
    name: "Subscriptions",
    userId: "1",
    categoryType: CategoryType.Expenses,
  ),
];
