import 'package:flutter/material.dart';

import 'models/app_user.dart';
import 'screens/login_screen.dart';
import 'screens/success_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';
import 'widgets/app_background.dart';
import 'widgets/brand_header.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sarajevo Reports',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}

/// Decides the first screen: a saved, still-valid login goes straight to the success page.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<AppUser?> _session = ApiService.restoreSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _Splash();
        }
        final user = snapshot.data;
        return user != null ? SuccessScreen(user: user) : const LoginScreen();
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BrandHeader(),
      body: AppBackground(
        child: Center(child: CircularProgressIndicator(color: AppColors.civic)),
      ),
    );
  }
}
