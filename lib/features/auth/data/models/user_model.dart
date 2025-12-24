import '../../domain/entities/user_entity.dart';
import '../../../../core/constants/firebase_constants.dart';

/// User model for data layer - handles Firebase serialization
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    required super.createdAt,
  });

  /// Convert Firebase user to UserModel
  factory UserModel.fromFirebaseUser(
    String uid,
    String email,
    String? displayName,
  ) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? email.split('@').first,
      createdAt: DateTime.now(),
    );
  }

  /// Convert Firestore document to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json[FirebaseConstants.userIdField] as String,
      email: json[FirebaseConstants.userEmailField] as String,
      displayName: json[FirebaseConstants.userDisplayNameField] as String,
      createdAt: DateTime.parse(json[FirebaseConstants.userCreatedAtField] as String),
    );
  }

  /// Convert UserModel to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirebaseConstants.userIdField: uid,
      FirebaseConstants.userEmailField: email,
      FirebaseConstants.userDisplayNameField: displayName,
      FirebaseConstants.userCreatedAtField: createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
