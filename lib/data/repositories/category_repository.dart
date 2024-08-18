import 'package:dio/dio.dart';

import '../models/category.dart';

class CategoryRepository {
  final Dio _dio;

  CategoryRepository(this._dio);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/api/v1/categories/get');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<List<Category>> getCategoriesWithTasks() async {
    try {
      final response = await _dio.get('/api/v1/categories/dashboard');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories with tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting categories with tasks: $e');
      return [];
    }
  }

  Future<Category> createCategory(String type) async {
    try {
      final response = await _dio.post('/api/v1/categories/create', data: {'type': type});
      if (response.statusCode == 200) {
        return Category.fromJson(response.data);
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      final response = await _dio.delete('/api/v1/categories/delete?category_id=$categoryId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }
}
