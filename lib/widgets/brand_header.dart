import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Navy bar with an amber bottom line and the "Sarajevo Reports" brand, like the website header.
class BrandHeader extends StatelessWidget implements PreferredSizeWidget {
  const BrandHeader({super.key, this.trailing});

  final Widget? trailing;

  // 56 for the bar + 3 for the amber line. Scaffold adds the status bar height itself.
  @override
  Size get preferredSize => const Size.fromHeight(59);

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navy,
        border: Border(bottom: BorderSide(color: AppColors.amber, width: 3)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                if (canGoBack)
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: 'Back',
                  )
                else
                  const SizedBox(width: 8),
                const _BrandMark(),
                const SizedBox(width: 10),
                const Text(
                  'Sarajevo Reports',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The small amber map-pin shape (a rounded square with one sharp corner, rotated).
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 4,
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: AppColors.amber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9),
            topRight: Radius.circular(9),
            bottomRight: Radius.circular(9),
          ),
        ),
      ),
    );
  }
}
