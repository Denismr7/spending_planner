import 'dart:convert';

class Budget {
  Budget({
    required this.smartBudget,
    required this.limit,
  });

  bool smartBudget;
  double limit;

  factory Budget.fromJson(Map<String, dynamic> json) {
    var limit = double.parse(json['limit'].toString());
    return Budget(
      smartBudget: json['smartBudget'],
      limit: limit,
    );
  }
}
