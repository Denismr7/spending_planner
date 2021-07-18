class Category {
  final String id;
  final String name;
  final double? amount;
  final CategoryType categoryType;

  const Category({
    required this.id,
    required this.name,
    required this.categoryType,
    this.amount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      categoryType: parseCategoryType(json['categoryType']),
    );
  }

  // Firebase can't store enums so we store the value of the enum
  // Ex: "Incomes"
  static CategoryType parseCategoryType(String value) {
    if (value == 'Incomes') return CategoryType.Incomes;
    if (value == 'Expenses') return CategoryType.Expenses;
    print('SPLAN.parseString() Invalid Category Type $value');
    throw Exception('Invalid Category Type $value');
  }
}

enum CategoryType { Incomes, Expenses }

extension ParseToString on CategoryType {
  String valueAsString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
