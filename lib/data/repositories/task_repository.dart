import 'package:dio/dio.dart';
import '../models/task.dart';

class TaskRepository {
  final Dio _dio;

  TaskRepository(this._dio);

  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/api/v1/tasks/get');
      if (response.statusCode == 200) {
        if (response.data == null) {
          return [];
        }
        if (response.data is List) {
          return (response.data as List)
              .map((json) => Task.fromJson(json))
              .toList();
        } else {
          print('Unexpected response format: ${response.data}');
          return [];
        }
      } else {
        throw Exception('Failed to get tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  Future<Task> getTask(int taskId) async {
    try {
      final response = await _dio.get('/api/v1/tasks/get?task_id=$taskId');
      if (response.statusCode == 200) {
        return Task.fromJson(response.data);
      } else {
        throw Exception('Failed to get task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting task: $e');
      rethrow;
    }
  }

  Future<void> updateTaskCategory(int taskId, int categoryId) async {
    try {
      final response = await _dio.put(
          '/api/v1/tasks/update/category?task_id=$taskId',
          data: {'category_id': categoryId});
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update task category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating task category: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createTask(
      String title, String description) async {
    try {
      final response = await _dio.post('/api/v1/tasks/create', data: {
        'title': title,
        'description': description,
      });
      print('Raw API Response: ${response.data}'); // Tambahkan logging ini
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('API response is not a valid JSON object');
        }
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(int taskId, String title, String description) async {
    try {
      final response =
          await _dio.put('/api/v1/tasks/update?task_id=$taskId', data: {
        'title': title,
        'description': description,
      });
      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final response =
          await _dio.delete('/api/v1/tasks/delete?task_id=$taskId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}
