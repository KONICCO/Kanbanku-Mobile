import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
final dio = Dio(BaseOptions(
  baseUrl: 'https://confidential-kellen-belajar-developer-d281a9bf.koyeb.app',
  validateStatus: (status) {
    return status! < 500;
  },
))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final userId = await storage.read(key: 'user_id');
        if (userId != null) {
          options.headers['Cookie'] = 'user_id=$userId';
        }
        return handler.next(options);
      },
    ),
  );
