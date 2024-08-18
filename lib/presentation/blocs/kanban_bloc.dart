import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbanku/data/models/auth.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/task.dart';
import '../../data/models/category.dart';
import '../../data/models/user.dart';

class KanbanState {
  final List<Task> tasks;
  final List<Category> categories;
  final User? user;
  final UserAuth? userauth;
  final String? error;

  KanbanState({
    required this.tasks,
    required this.categories,
    this.user,
    this.userauth,
    this.error,
  });
}

class KanbanCubit extends Cubit<KanbanState> {
  final TaskRepository _taskRepository;
  final CategoryRepository _categoryRepository;
  final AuthRepository _authRepository;

  KanbanCubit(
    this._taskRepository,
    this._categoryRepository,
    this._authRepository,
  ) : super(KanbanState(tasks: [], categories: [], userauth: null));

  Future<void> loadData() async {
    try {
      final tasks = await _taskRepository.getTasks();
      print('Loaded tasks: $tasks'); // Tambahkan log ini
      final categories = await _categoryRepository.getCategories();
      print('Loaded categories: $categories'); // Tambahkan log ini
      emit(KanbanState(
        tasks: tasks,
        categories: categories,
        userauth: state.userauth,
        error: null,
      ));
    } catch (e) {
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        userauth: state.userauth,
        error: 'Failed to load data: $e',
      ));
    }
  }

  Future<void> updateTaskCategory(
      int taskId, int currentCategoryId, bool moveRight) async {
    final categories = state.categories;
    final currentIndex =
        categories.indexWhere((c) => c.id == currentCategoryId);
    if (currentIndex == -1) return;

    int newIndex;
    if (moveRight) {
      newIndex = (currentIndex + 1) % categories.length;
    } else {
      newIndex = (currentIndex - 1 + categories.length) % categories.length;
    }

    final newCategoryId = categories[newIndex].id;
    await _taskRepository.updateTaskCategory(taskId, newCategoryId);
    await loadData();
  }

  Future<void> createTask(String title, String description, int categoryId) async {
    try {
      final response = await _taskRepository.createTask(title,
          description,categoryId); //Raw API Response: {message: success create new task, task_id: 27, user_id: 1}
      print("Raw API Response: $response"); // Tambahkan logging ini
      print(
          "Raw API Response: ${response['user_id']}"); // Tambahkan logging ini

      // Periksa apakah respons memiliki semua field yang diperlukan
      if (response['message'] == 'success create new task' &&
          response['task_id'] != null &&
          response['user_id'] != null) {
        await loadData();
        print('State after createTask: ${state.tasks}'); 
        emit(KanbanState(
          tasks: state.tasks,
          categories: state.categories,
          userauth: state.userauth,
          error: null,
        ));
      } else {
        throw Exception('Invalid task data received from API');
      }
    } catch (e) {
      print('Error in createTask: $e'); // Tambahkan logging ini
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        userauth: state.userauth,
        error: 'Failed to create task: $e',
      ));
    }
  }

  Future<void> deleteTask(int taskId) async {
    await _taskRepository.deleteTask(taskId);
    await loadData();
  }

  Future<void> createCategory(String type) async {
    await _categoryRepository.createCategory(type);
    await loadData();
  }

  Future<void> deleteCategory(int categoryId) async {
    await _categoryRepository.deleteCategory(categoryId);
    await loadData();
  }

  Future<void> login(String email, String password) async {
    try {
      final userauth = await _authRepository.login(email, password);
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        userauth: userauth,
        error: null,
      ));
      await loadData();
    } catch (e) {
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        userauth: null,
        error: 'Login failed: $e',
      ));
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(KanbanState(tasks: [], categories: [], user: null));
    } catch (e) {
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        user: state.user,
        error: 'Logout failed: $e',
      ));
    }
  }

  Future<void> register(String fullname, String email, String password) async {
    try {
      final user = await _authRepository.register(fullname, email, password);
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        user: user,
        error: null,
      ));
    } catch (e) {
      emit(KanbanState(
        tasks: state.tasks,
        categories: state.categories,
        user: null,
        error: 'Register failed: $e',
      ));
    }
  }
}
