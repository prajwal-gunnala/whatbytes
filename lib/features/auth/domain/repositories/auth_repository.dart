import '../entities/user_entity.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  /// Register with email and password
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out
  Future<void> signOut();

  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Stream of auth state changes
  Stream<UserEntity?> authStateChanges();
}
