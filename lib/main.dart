import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/tasks/presentation/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set system UI overlay style (status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    // Wrap app with ProviderScope for Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthStateHandler(),
    );
  }
}

/// Handles auth state and navigates to appropriate screen
class AuthStateHandler extends ConsumerWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        // User is authenticated - show task list
        return const TaskListScreen();
      },
      loading: () => const SplashScreen(),
      error: (error, _) => const LoginScreen(),
    );
  }
}

// Splash screen widget
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            // App name with gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF22D3EE)],
              ).createShader(bounds),
              child: const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Tagline
            Text(
              AppConstants.appTagline,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22D3EE)),
            ),
          ],
        ),
      ),
    );
  }
}
