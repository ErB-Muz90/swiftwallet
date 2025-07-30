class Budget {
  final String id;
  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> categoryIds;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.categoryIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'categoryIds': categoryIds,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      categoryIds: List<String>.from(json['categoryIds'] as List),
    );
  }
}
