import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';

/// Implementation of TaskRepository
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImpl({
    required TaskRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<TaskEntity> createTask({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskPriority priority,
  }) async {
    try {
      return await _remoteDataSource.createTask(
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TaskEntity>> getTasks(String userId) async {
    try {
      return await _remoteDataSource.getTasks(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskEntity?> getTaskById(String taskId) async {
    try {
      return await _remoteDataSource.getTaskById(taskId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskEntity> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) async {
    try {
      return await _remoteDataSource.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        isCompleted: isCompleted,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _remoteDataSource.deleteTask(taskId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskEntity> toggleTaskCompletion(String taskId) async {
    try {
      return await _remoteDataSource.toggleTaskCompletion(taskId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<TaskEntity>> tasksStream(String userId) {
    return _remoteDataSource.tasksStream(userId);
  }
}
