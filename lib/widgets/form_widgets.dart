import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bold label above a field, like the website forms.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.optional = false,
  });

  final String label;
  final Widget child;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: AppText.label,
            children: [
              if (optional)
                const TextSpan(
                  text: ' (optional)',
                  style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.slate),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.optional = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: label,
      optional: optional,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        validator: validator,
        decoration: AppTheme.input(hint: hint),
      ),
    );
  }
}

/// Password field with a Show / Hide button.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: widget.label,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _hidden,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        validator: widget.validator,
        onFieldSubmitted: (_) => widget.onSubmitted?.call(),
        decoration: AppTheme.input(
          suffix: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              onPressed: () => setState(() => _hidden = !_hidden),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.civicDark,
                minimumSize: const Size(56, 36),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              child: Text(_hidden ? 'Show' : 'Hide'),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width blue button with a spinner while loading.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.civic,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.civic,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}

/// Green success / red error message box (like Bootstrap alerts).
class AlertBox extends StatelessWidget {
  const AlertBox({super.key, required this.message, this.success = false});

  final String message;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final background = success ? const Color(0xFFD1E7DD) : const Color(0xFFF8D7DA);
    final border = success ? const Color(0xFFBADBCC) : const Color(0xFFF5C2C7);
    final text = success ? const Color(0xFF0F5132) : const Color(0xFF842029);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(message, style: TextStyle(color: text, fontSize: 14, height: 1.35)),
    );
  }
}
