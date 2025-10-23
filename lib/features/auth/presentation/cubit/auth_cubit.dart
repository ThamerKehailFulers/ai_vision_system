import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      _listenToAuthChanges();
    } catch (e) {
      print('Auth initialization error: $e');
      emit(AuthError(message: 'Authentication service unavailable'));
    }
  }

  void _listenToAuthChanges() {
    try {
      _authStateSubscription = _authRepository.authStateChanges.listen(
        (user) {
          if (user != null) {
            emit(
              AuthAuthenticated(
                uid: user.uid,
                email: user.email,
                fullName: user.fullName,
              ),
            );
          } else {
            emit(AuthUnauthenticated());
          }
        },
        onError: (error) {
          print('Auth state error: $error');
          emit(AuthError(message: 'Authentication error occurred'));
        },
      );
    } catch (e) {
      print('Failed to listen to auth changes: $e');
      emit(AuthError(message: 'Failed to initialize authentication'));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    emit(AuthLoading());

    try {
      print('AuthCubit: Starting sign up process');

      final result = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      result.fold(
        (error) {
          print('AuthCubit: Sign up failed with error: $error');
          emit(AuthError(message: error));
        },
        (user) {
          print('AuthCubit: Sign up successful for user: ${user.uid}');
          emit(
            AuthAuthenticated(
              uid: user.uid,
              email: user.email,
              fullName: user.fullName,
            ),
          );
        },
      );
    } catch (e) {
      print('AuthCubit: Unexpected error during sign up: $e');

      if (e.toString().contains('PigeonUserDetails')) {
        emit(
          AuthError(
            message:
                'Authentication service error. Please restart the app and try again.',
          ),
        );
      } else {
        emit(AuthError(message: 'Sign up failed: ${e.toString()}'));
      }
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(AuthError(message: error)),
      (user) => emit(
        AuthAuthenticated(
          uid: user.uid,
          email: user.email,
          fullName: user.fullName,
        ),
      ),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await _authRepository.signOut();

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());

    final result = await _authRepository.resetPassword(email: email);

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) => emit(AuthPasswordResetSent(email: email)),
    );
  }

  Future<void> checkCurrentUser() async {
    emit(AuthLoading());

    final result = await _authRepository.getCurrentUser();

    result.fold((error) => emit(AuthError(message: error)), (user) {
      if (user != null) {
        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email,
            fullName: user.fullName,
          ),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
