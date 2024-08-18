class Category {
  final int id;
  final String type;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.type,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      type: json['type'],
      userId: json['user_id']as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}