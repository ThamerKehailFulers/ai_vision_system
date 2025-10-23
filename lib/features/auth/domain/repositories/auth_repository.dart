import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });

  Future<Either<String, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<String, void>> signOut();

  Future<Either<String, void>> resetPassword({required String email});

  Future<Either<String, UserEntity?>> getCurrentUser();

  Stream<UserEntity?> get authStateChanges;
}
