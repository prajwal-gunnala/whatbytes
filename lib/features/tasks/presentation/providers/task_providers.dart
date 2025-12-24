import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Provider for TaskRemoteDataSource
final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource();
});

/// Provider for TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    remoteDataSource: ref.read(taskRemoteDataSourceProvider),
  );
});

/// Provider for tasks stream (real-time updates)
final tasksStreamProvider = StreamProvider.autoDispose<List<TaskEntity>>((ref) {
  final authState = ref.watch(authStateProvider);
  final repository = ref.watch(taskRepositoryProvider);

  final user = authState.value;
  if (user == null) {
    return Stream.value([]);
  }

  return repository.tasksStream(user.uid);
});

/// Task actions provider (for CRUD operations)
class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Create a new task
  Future<bool> createTask({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskPriority priority,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createTask(
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Update a task
  Future<bool> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        isCompleted: isCompleted,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTask(taskId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Toggle task completion
  Future<bool> toggleTaskCompletion(String taskId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.toggleTaskCompletion(taskId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}

/// Task actions provider
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  return TaskNotifier(ref.read(taskRepositoryProvider));
});

/// Filter and sort state providers
enum TaskFilter { all, pending, completed }

enum TaskSortBy { dateCreated, dueDate, priority }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final taskSortProvider = StateProvider<TaskSortBy>((ref) => TaskSortBy.dueDate);

/// Filtered and sorted tasks provider
final filteredTasksProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);
  final filter = ref.watch(taskFilterProvider);
  final sortBy = ref.watch(taskSortProvider);

  return tasksAsync.when(
    data: (tasks) {
      // Apply filter
      List<TaskEntity> filtered;
      switch (filter) {
        case TaskFilter.pending:
          filtered = tasks.where((task) => !task.isCompleted).toList();
          break;
        case TaskFilter.completed:
          filtered = tasks.where((task) => task.isCompleted).toList();
          break;
        case TaskFilter.all:
          filtered = tasks;
      }

      // Apply sort
      switch (sortBy) {
        case TaskSortBy.dateCreated:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case TaskSortBy.dueDate:
          filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          break;
        case TaskSortBy.priority:
          filtered.sort((a, b) {
            const priorityOrder = {
              TaskPriority.high: 0,
              TaskPriority.medium: 1,
              TaskPriority.low: 2,
            };
            return (priorityOrder[a.priority] ?? 2)
                .compareTo(priorityOrder[b.priority] ?? 2);
          });
          break;
      }

      return filtered;
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});
