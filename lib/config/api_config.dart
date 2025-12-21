/// API Configuration
/// Ganti base URL sesuai environment
class ApiConfig {
  // Development
  static const String devUrl = 'http://127.0.0.1:8000/api';
  
  // Android Emulator
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api';
  
  // Production (ganti dengan domain/IP server production)
  static const String prodUrl = 'https://api.yourdomain.com/api';
  
  // Current environment - GANTI INI
  // Set to androidEmulator for local backend when testing on Android emulator.
  // Switch to dev for desktop/web, or prod for production.
  static const Environment currentEnv = Environment.androidEmulator;
  
  // Get base URL based on environment
  static String get baseUrl {
    switch (currentEnv) {
      case Environment.dev:
        return devUrl;
      case Environment.androidEmulator:
        return androidEmulatorUrl;
      case Environment.prod:
        return prodUrl;
    }
  }
  
  // Request timeout
  static const Duration timeout = Duration(seconds: 30);
  
  // Enable debug logs
  static const bool enableLogs = true;
}

enum Environment {
  dev,
  androidEmulator,
  prod,
}
