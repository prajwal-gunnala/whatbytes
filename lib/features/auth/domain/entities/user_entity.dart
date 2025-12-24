import 'package:equatable/equatable.dart';

/// User entity representing authenticated user
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, displayName, createdAt];

  @override
  String toString() {
    return 'UserEntity(uid: $uid, email: $email, displayName: $displayName)';
  }
}
