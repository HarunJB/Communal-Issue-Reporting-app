import 'package:flutter/material.dart';

/// Same palette as the website (site.css).
class AppColors {
  static const navy = Color(0xFF17324D);
  static const civic = Color(0xFF2563A6);
  static const civicDark = Color(0xFF1D4F85);
  static const pale = Color(0xFFEAF2F8);
  static const amber = Color(0xFFF2B544);
  static const amberDark = Color(0xFFE0A02A);
  static const offWhite = Color(0xFFF7F8F6);
  static const slate = Color(0xFF475569);
  static const border = Color(0xFFCBD5E1);
  static const cardBorder = Color(0xFFE2E8F0);
  static const hint = Color(0xFF94A3B8);
  static const danger = Color(0xFFB42318);
}

class AppText {
  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );

  static const subtitle = TextStyle(
    fontSize: 15,
    height: 1.4,
    color: AppColors.slate,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.navy,
  );
}

class AppTheme {
  // No custom font on purpose: the website uses the system font stack,
  // and Flutter's default is the system font too (Roboto / San Francisco / Segoe UI).
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.civic).copyWith(
      primary: AppColors.civic,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      onSecondary: AppColors.navy,
      surface: Colors.white,
      onSurface: AppColors.navy,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.offWhite,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.civic),
    );
  }

  /// Text field look: white fill, light border, civic-blue focus ring.
  static InputDecoration input({String? hint, Widget? suffix}) {
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hint),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffix,
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.civic, 2),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger, 2),
      errorStyle: const TextStyle(color: AppColors.danger, fontSize: 13),
    );
  }
}
