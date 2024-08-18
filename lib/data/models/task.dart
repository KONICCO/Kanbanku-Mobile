class Task {
  final int id;
  final String title;
  final String description;
  final int categoryId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int, // Pastikan ini adalah integer
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['category_id'] as int, // Pastikan ini adalah integer
      userId: json['user_id'] as int, // Pastikan ini adalah integer
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}
