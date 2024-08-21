import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kanbanku/data/repositories/auth_repository.dart';
import 'package:kanbanku/data/repositories/category_repository.dart';
import 'package:kanbanku/data/repositories/task_repository.dart';
import 'package:kanbanku/presentation/blocs/kanban_bloc.dart';
import 'package:kanbanku/presentation/views/dasboard.dart';
import 'package:kanbanku/presentation/views/login.dart';
import 'package:kanbanku/presentation/views/register.dart';

void main() {
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

  runApp(MyApp(dio: dio, storage: storage));
}

class MyApp extends StatelessWidget {
  final Dio dio;
  final FlutterSecureStorage storage;

  MyApp({required this.dio, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => KanbanCubit(
            TaskRepository(dio),
            CategoryRepository(dio),
            AuthRepository(dio, storage),
          )..loadData(), // Pastikan data dimuat saat aplikasi dimulai
        ),
      ],
      child: MaterialApp(
        title: 'Kanban App',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 255, 255, 255), // Warna bagian atas dari gradien
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<KanbanCubit, KanbanState>(
            builder: (context, state) {
              print(state);
              print(state.userauth);

              if (state.userauth != null) {
                return DashboardScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
          '/register': (context) => RegisterScreen(),
          '/dashboard': (context) => DashboardScreen(),
        },
      ),
    );
  }
}