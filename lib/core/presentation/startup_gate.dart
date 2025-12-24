import 'package:flutter/material.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import 'auth_state_handler.dart';

/// Ensures the splash screen is visible for a minimum duration.
class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  static const _minSplashDuration = Duration(milliseconds: 3000);
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_minSplashDuration).then((_) {
      if (!mounted) return;
      setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
          : const AuthStateHandler(key: ValueKey('auth')),
    );
  }
}
