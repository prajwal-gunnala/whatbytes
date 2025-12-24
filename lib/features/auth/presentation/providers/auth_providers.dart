import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
});

/// Provider for auth state stream
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

/// Provider for current user (synchronous)
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.getCurrentUser();
});

/// Auth actions provider (for sign in, register, sign out)
class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signIn(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Register with email and password
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AsyncValue.data(user);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Auth actions provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
