class User {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final DateTime createdAt;
  final List<String> expenseIds;
  final List<String> budgetIds;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.createdAt,
    required this.expenseIds,
    required this.budgetIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'expenseIds': expenseIds,
      'budgetIds': budgetIds,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expenseIds: List<String>.from(json['expenseIds'] as List),
      budgetIds: List<String>.from(json['budgetIds'] as List),
    );
  }
}
