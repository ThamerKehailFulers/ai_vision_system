import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<String, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      print('Starting user registration for email: $email');

      // Create user with Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User credential created successfully');

      final user = userCredential.user;
      if (user == null) {
        print('User is null after creation');
        return left('Failed to create user');
      }

      print('User created with UID: ${user.uid}');

      // Create user entity immediately with basic Firebase Auth data
      final userEntity = UserEntity(
        uid: user.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      print('User entity created: ${userEntity.toMap()}');

      // Save user data to Firestore (separate try-catch to not fail registration)
      try {
        print('Attempting to save user data to Firestore for UID: ${user.uid}');
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userEntity.toMap());
        print('Successfully saved user data to Firestore');
      } catch (firestoreError) {
        print('Firestore save error: $firestoreError');
        print('Firestore error type: ${firestoreError.runtimeType}');
        // Continue anyway - user is created in Firebase Auth
      }

      // Update display name (separate try-catch to not fail registration)
      try {
        await user.updateDisplayName(fullName);
        print('Display name updated successfully');
      } catch (displayNameError) {
        print('Failed to update display name: $displayNameError');
        // Continue anyway - not critical
      }

      // Force refresh to ensure all user data is current
      try {
        await user.reload();
        print('User data refreshed successfully');
      } catch (reloadError) {
        print('Failed to reload user: $reloadError');
        // Continue anyway
      }

      return right(userEntity);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during signup: ${e.code} - ${e.message}');
      return left(_getAuthErrorMessage(e));
    } catch (e) {
      print('Unexpected error during signup: ${e.toString()}');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: ${StackTrace.current}');

      // Return a more specific error message
      if (e.toString().contains('PigeonUserDetails')) {
        return left('Authentication service error. Please try again.');
      }

      return left('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithEmailAndPassword({
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
        return left('User not found');
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return left('User data not found');
      }

      final userEntity = UserEntity.fromMap(userDoc.data()!);
      return right(userEntity);
    } on FirebaseAuthException catch (e) {
      return left(_getAuthErrorMessage(e));
    } catch (e) {
      return left('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(null);
    } catch (e) {
      return left('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(_getAuthErrorMessage(e));
    } catch (e) {
      return left('Failed to send reset email: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        print('getCurrentUser: No current user');
        return right(null);
      }

      print('getCurrentUser: Current user UID: ${user.uid}');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        print('getCurrentUser: User document does not exist in Firestore');

        // Return a basic UserEntity from Firebase Auth data
        return right(
          UserEntity(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Unknown User',
            createdAt: DateTime.now(),
          ),
        );
      }

      final userData = userDoc.data();
      if (userData == null) {
        print('getCurrentUser: User document exists but data is null');
        return right(null);
      }

      print('getCurrentUser: Retrieved user data: $userData');
      final userEntity = UserEntity.fromMap(userData);
      return right(userEntity);
    } catch (e) {
      print('getCurrentUser error: $e');
      return left('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        print('Auth state changed: User is null');
        return null;
      }

      try {
        print('Auth state changed: User ${user.uid} is logged in');

        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          print(
            'User document does not exist in Firestore for UID: ${user.uid}',
          );

          // Create a basic UserEntity from Firebase Auth data
          return UserEntity(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Unknown User',
            createdAt: DateTime.now(),
          );
        }

        final userData = userDoc.data();
        if (userData == null) {
          print('User document exists but data is null');
          return null;
        }

        print('Retrieved user data from Firestore: $userData');
        return UserEntity.fromMap(userData);
      } catch (e) {
        print('Error in authStateChanges: $e');

        // Fallback: create UserEntity from Firebase Auth data
        return UserEntity(
          uid: user.uid,
          email: user.email ?? '',
          fullName: user.displayName ?? 'Unknown User',
          createdAt: DateTime.now(),
        );
      }
    });
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
