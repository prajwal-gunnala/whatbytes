import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      return await _remoteDataSource.registerWithEmailPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _remoteDataSource.getCurrentUserData();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _remoteDataSource.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _remoteDataSource.getCurrentUserData();
    });
  }
}
