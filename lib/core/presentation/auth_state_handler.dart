import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

/// Handles auth state and routes to the correct first screen.
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
        return const HomeShell();
      },
      loading: () => const SplashScreen(),
      error: (error, _) => const LoginScreen(),
    );
  }
}
