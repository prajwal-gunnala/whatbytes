import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:whatbytes/core/constants/app_constants.dart';
import 'package:whatbytes/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('Splash shows app name', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
