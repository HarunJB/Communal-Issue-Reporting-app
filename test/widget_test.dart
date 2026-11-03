import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_mobile/screens/login_screen.dart';
import 'package:product_mobile/theme/app_theme.dart';

void main() {
  testWidgets('Login screen shows the welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
