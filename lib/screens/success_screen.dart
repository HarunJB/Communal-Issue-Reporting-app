import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import 'login_screen.dart';

/// Shown after a successful login: confirms the role (User / Operator / Admin).
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.user});

  final AppUser user;

  Future<void> _logout(BuildContext context) async {
    await ApiService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      headerTrailing: OutlinedButton(
        onPressed: () => _logout(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white70),
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Log out'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(color: AppColors.pale, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text(
                '✓',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.civic),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Login successful', textAlign: TextAlign.center, style: AppText.title),
          const SizedBox(height: 4),
          const Text(
            'You are signed in as',
            textAlign: TextAlign.center,
            style: AppText.subtitle,
          ),
          const SizedBox(height: 20),
          Center(child: _RoleBadge(role: user.role)),
          const SizedBox(height: 28),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 20),
          _Detail(label: 'Name', value: user.name),
          const SizedBox(height: 14),
          _Detail(label: 'Email', value: user.email),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color background;
    late final Color foreground;
    late final Color border;

    switch (role) {
      case 'admin':
        label = 'Admin';
        background = AppColors.navy;
        foreground = Colors.white;
        border = AppColors.navy;
      case 'operator':
        label = 'Operator';
        background = AppColors.amber;
        foreground = AppColors.navy;
        border = AppColors.amber;
      default:
        label = role == 'citizen' ? 'User' : role;
        background = AppColors.pale;
        foreground = AppColors.navy;
        border = const Color(0xFFBFD3E6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
