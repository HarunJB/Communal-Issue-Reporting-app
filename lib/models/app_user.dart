class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.displayName,
  });

  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? displayName;

  /// 'citizen', 'operator' or 'admin'
  final String role;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        displayName: json['displayName'] as String?,
        role: json['role'] as String,
      );

  /// Name shown in the UI.
  String get name =>
      (displayName != null && displayName!.isNotEmpty) ? displayName! : firstName;
}
