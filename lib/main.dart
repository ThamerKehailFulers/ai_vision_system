import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/notification_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'firebase_options.dart';

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialize notification service
    await NotificationService().initialize();
    print('Notification service initialized');

    // Subscribe to default topics (optional)
    await NotificationService().subscribeToTopic('all_users');
    await NotificationService().subscribeToTopic('detections');
    print('Subscribed to notification topics');
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
        navigatorKey: navigatorKey, // Add navigator key for notification navigation
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
