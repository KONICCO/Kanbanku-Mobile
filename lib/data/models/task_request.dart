class TaskRequest {
  final String message;
  final int user_id;
  final int task_id;

  TaskRequest({
    required this.message,
    required this.user_id,
    required this.task_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user_id': user_id,
      'task_id': task_id,
    };
  }
}
