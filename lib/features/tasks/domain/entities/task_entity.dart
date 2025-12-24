import 'package:equatable/equatable.dart';

/// Task priority levels
enum TaskPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

/// Task entity representing a task item
class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        dueDate,
        priority,
        isCompleted,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted)';
  }
}
