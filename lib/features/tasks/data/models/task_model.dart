import '../../domain/entities/task_entity.dart';
import '../../../../core/constants/firebase_constants.dart';

/// Task model for data layer - handles Firebase serialization
class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.priority,
    required super.isCompleted,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Convert Firestore document to TaskModel
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json[FirebaseConstants.taskIdField] as String,
      userId: json[FirebaseConstants.taskUserIdField] as String,
      title: json[FirebaseConstants.taskTitleField] as String,
      description: json[FirebaseConstants.taskDescriptionField] as String? ?? '',
      dueDate: DateTime.parse(json[FirebaseConstants.taskDueDateField] as String),
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json[FirebaseConstants.taskPriorityField],
        orElse: () => TaskPriority.medium,
      ),
      isCompleted: json[FirebaseConstants.taskIsCompletedField] as bool? ?? false,
      createdAt: DateTime.parse(json[FirebaseConstants.taskCreatedAtField] as String),
      updatedAt: DateTime.parse(json[FirebaseConstants.taskUpdatedAtField] as String),
    );
  }

  /// Convert TaskModel to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirebaseConstants.taskIdField: id,
      FirebaseConstants.taskUserIdField: userId,
      FirebaseConstants.taskTitleField: title,
      FirebaseConstants.taskDescriptionField: description,
      FirebaseConstants.taskDueDateField: dueDate.toIso8601String(),
      FirebaseConstants.taskPriorityField: priority.name,
      FirebaseConstants.taskIsCompletedField: isCompleted,
      FirebaseConstants.taskCreatedAtField: createdAt.toIso8601String(),
      FirebaseConstants.taskUpdatedAtField: updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
