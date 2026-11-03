import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_background.dart';
import 'brand_header.dart';

/// Page frame shared by login, register and success: header, background, centered white card.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.headerTrailing,
    this.maxWidth = 420,
  });

  final Widget child;
  final Widget? headerTrailing;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandHeader(trailing: headerTrailing),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: AuthCard(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White card with a thin amber strip on top (the website's .auth-card).
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(23, 50, 77, 0.08),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 4, color: AppColors.amber),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
