/// Same messages as the website. The server validates again, this is only for quick feedback.
class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phonePattern = RegExp(r'^[+()\d\s\-]{6,}$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email.';
    if (!_emailPattern.hasMatch(text)) return 'Please enter a valid email address.';
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password.';
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// Phone is optional: only checked when something is typed.
  static String? optionalPhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!_phonePattern.hasMatch(text)) return 'Please enter a valid phone number.';
    return null;
  }
}
