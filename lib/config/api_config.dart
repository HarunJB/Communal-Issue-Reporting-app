import 'package:flutter/foundation.dart';

/// Where the .NET backend lives.
///
/// CHANGE [port] to the http port printed by `dotnet run`
/// (look for: "Now listening on: http://localhost:XXXX").
///
/// For a physical phone, pass your computer's LAN address instead:
///   flutter run --dart-define=API_URL=http://192.168.1.20:5000
class ApiConfig {
  static const int port = 5141;

  static const String _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (kIsWeb) return 'http://localhost:$port';
    // The Android emulator reaches your computer through 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:$port';
    return 'http://localhost:$port';
  }
}
