class Budget {
  Budget({
    required this.smartBudget,
    required this.limit,
    this.percentage,
  });

  bool smartBudget;
  int? percentage;
  double limit;

  factory Budget.fromJson(Map<String, dynamic> json) {
    var limit = double.parse(json['limit'].toString());
    return Budget(
      smartBudget: json['smartBudget'],
      percentage: json['percentage'] ?? null,
      limit: limit,
    );
  }

  Map<String, dynamic> toJson() => {
        'smartBudget': smartBudget,
        'limit': limit,
        'percentage': percentage,
      };
}
