import '../entities/task_entity.dart';

/// Task repository interface
abstract class TaskRepository {
  /// Create a new task
  Future<TaskEntity> createTask({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskPriority priority,
  });

  /// Get all tasks for a user
  Future<List<TaskEntity>> getTasks(String userId);

  /// Get a single task by ID
  Future<TaskEntity?> getTaskById(String taskId);

  /// Update a task
  Future<TaskEntity> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  });

  /// Delete a task
  Future<void> deleteTask(String taskId);

  /// Toggle task completion status
  Future<TaskEntity> toggleTaskCompletion(String taskId);

  /// Stream of tasks for a user (real-time updates)
  Stream<List<TaskEntity>> tasksStream(String userId);
}
