import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../../core/constants/firebase_constants.dart';

/// Remote data source for authentication operations
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign in with email and password
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null after sign in');
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found in Firestore');
      }

      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  /// Register with email and password
  Future<UserModel> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null after registration');
      }

      // Update display name
      await user.updateDisplayName(displayName);

      // Create user model
      final userModel = UserModel.fromFirebaseUser(
        user.uid,
        user.email!,
        displayName,
      );

      // Save user data to Firestore
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  /// Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      return await _getOrCreateUserData(user);
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  Future<UserModel> _getOrCreateUserData(User firebaseUser) async {
    final userDocRef = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(firebaseUser.uid);

    final userDoc = await userDocRef.get();
    if (userDoc.exists && userDoc.data() != null) {
      return UserModel.fromJson(userDoc.data()!);
    }

    final email = firebaseUser.email;
    if (email == null || email.isEmpty) {
      throw Exception('Firebase user email is missing');
    }

    final createdUser = UserModel.fromFirebaseUser(
      firebaseUser.uid,
      email,
      firebaseUser.displayName,
    );

    await userDocRef.set(createdUser.toJson());
    return createdUser;
  }

  /// Stream of auth state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  /// Stream of user entities derived from auth state
  Stream<UserModel?> userModelChanges() {
    return authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _getOrCreateUserData(firebaseUser);
    });
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    final message = e.message ?? '';

    // Common Android misconfiguration seen with Firebase Auth reCAPTCHA/Play Services.
    // This is not a code bug — usually SHA-1/SHA-256 or google-services.json is outdated.
    if (message.contains('CONFIGURATION_NOT_FOUND')) {
      return 'Firebase Auth is not fully configured for this Android app (CONFIGURATION_NOT_FOUND).\n'
          'Fix: Firebase Console → Project Settings → Your apps (Android) → add SHA-1 & SHA-256 → download the updated google-services.json and replace android/app/google-services.json.\n'
          'Then run: flutter clean && flutter run.';
    }

    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        if (message.isNotEmpty) return message;
        return 'Authentication failed';
    }
  }
}
