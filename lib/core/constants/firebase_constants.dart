/// Firebase collection names
class FirebaseConstants {
  // Private constructor
  FirebaseConstants._();

  // Collection names
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';

  // User fields
  static const String userIdField = 'id';
  static const String userEmailField = 'email';
  static const String userDisplayNameField = 'displayName';
  static const String userCreatedAtField = 'createdAt';

  // Task fields
  static const String taskIdField = 'id';
  static const String taskUserIdField = 'userId';
  static const String taskTitleField = 'title';
  static const String taskDescriptionField = 'description';
  static const String taskDueDateField = 'dueDate';
  static const String taskPriorityField = 'priority';
  static const String taskIsCompletedField = 'isCompleted';
  static const String taskCreatedAtField = 'createdAt';
  static const String taskUpdatedAtField = 'updatedAt';
}
