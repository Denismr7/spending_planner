class Category {
  final String id;
  final String name;
  final String userId;
  final double? amount;
  final CategoryType categoryType;

  const Category({
    required this.id,
    required this.name,
    required this.userId,
    required this.categoryType,
    this.amount,
  });
}

enum CategoryType { Incomes, Expenses }

extension ParseToString on CategoryType {
  String valueAsString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
