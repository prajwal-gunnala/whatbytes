import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../../../core/constants/firebase_constants.dart';

/// Remote data source for task operations
class TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskRemoteDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new task
  Future<TaskModel> createTask({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskPriority priority,
  }) async {
    try {
      final taskRef = _firestore.collection(FirebaseConstants.tasksCollection).doc();
      final now = DateTime.now();

      final task = TaskModel(
        id: taskRef.id,
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      await taskRef.set(task.toJson());
      return task;
    } catch (e) {
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }

  /// Get all tasks for a user
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.tasksCollection)
          .where(FirebaseConstants.taskUserIdField, isEqualTo: userId)
          .orderBy(FirebaseConstants.taskCreatedAtField, descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks: ${e.toString()}');
    }
  }

  /// Get a single task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.tasksCollection)
          .doc(taskId)
          .get();

      if (!doc.exists || doc.data() == null) return null;

      return TaskModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get task: ${e.toString()}');
    }
  }

  /// Update a task
  Future<TaskModel> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) async {
    try {
      final taskRef = _firestore.collection(FirebaseConstants.tasksCollection).doc(taskId);
      final taskDoc = await taskRef.get();

      if (!taskDoc.exists || taskDoc.data() == null) {
        throw Exception('Task not found');
      }

      final currentTask = TaskModel.fromJson(taskDoc.data()!);
      final updatedTask = currentTask.copyWith(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        isCompleted: isCompleted,
        updatedAt: DateTime.now(),
      );

      await taskRef.update(updatedTask.toJson());
      return updatedTask;
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.tasksCollection)
          .doc(taskId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  /// Toggle task completion status
  Future<TaskModel> toggleTaskCompletion(String taskId) async {
    try {
      final taskRef = _firestore.collection(FirebaseConstants.tasksCollection).doc(taskId);
      final taskDoc = await taskRef.get();

      if (!taskDoc.exists || taskDoc.data() == null) {
        throw Exception('Task not found');
      }

      final currentTask = TaskModel.fromJson(taskDoc.data()!);
      final updatedTask = currentTask.copyWith(
        isCompleted: !currentTask.isCompleted,
        updatedAt: DateTime.now(),
      );

      await taskRef.update(updatedTask.toJson());
      return updatedTask;
    } catch (e) {
      throw Exception('Failed to toggle task: ${e.toString()}');
    }
  }

  /// Stream of tasks for a user (real-time updates)
  Stream<List<TaskModel>> tasksStream(String userId) {
    try {
      return _firestore
          .collection(FirebaseConstants.tasksCollection)
          .where(FirebaseConstants.taskUserIdField, isEqualTo: userId)
          .orderBy(FirebaseConstants.taskCreatedAtField, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to stream tasks: ${e.toString()}');
    }
  }
}
