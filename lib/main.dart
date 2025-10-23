import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Add a small delay to ensure Firebase is fully ready
    await Future.delayed(const Duration(milliseconds: 500));
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue running the app even if Firebase fails to initialize
  }

  runApp(const AIVisionSystemApp());
}

class AIVisionSystemApp extends StatelessWidget {
  const AIVisionSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authCubit = AuthCubit(AuthRepositoryImpl());
        // Delay checkCurrentUser to ensure Firebase is ready
        Future.delayed(const Duration(milliseconds: 100), () {
          authCubit.checkCurrentUser();
        });
        return authCubit;
      },
      child: MaterialApp(
        title: 'AI Vision System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
