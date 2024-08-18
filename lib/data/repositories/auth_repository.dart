import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kanbanku/data/models/user.dart';
import 'package:kanbanku/data/models/auth.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<UserAuth> login(String email, String password) async {
    try {
      final response = await _dio.post('/api/v1/users/login', 
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.data['message'] == 'login success') {
        final userId = response.data['user_id'].toString();
        await _storage.write(key: 'user_id', value: userId);
        return UserAuth(
          id: int.parse(userId),
          email: email,
        );
      } else {
        throw Exception('Login failed: ${response.data['message']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/v1/users/logout',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      await _storage.delete(key: 'user_id');
    } catch (e) {
      print('Logout failed: $e');
      rethrow;
    }
  }

  Future<User> register(String fullname, String email, String password) async {
    final response = await _dio.post('/api/v1/users/register', data: {
      'fullname': fullname,
      'email': email,
      'password': password,
    });
    return User.fromJson(response.data);
  }
}
