import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFFE94057); // brand pink
  static const _secondary = Color(0xFFFF80B0);

  static ThemeData dark() {
    const bg = Color(0xFF1B1C23);
    const surface = Color(0xFF2A2F45);
    const surfaceAlt = Color(0xFF1C2932);

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: false,
      scaffoldBackgroundColor: bg,
      primaryColor: _primary,
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        secondary: _secondary,
        surface: surface,
        background: bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF333238),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      extensions: const [
        AppColors(
          background: bg,
          surface: surface,
          surfaceAlt: surfaceAlt,
          onBackground: Colors.white,
          onSurface: Colors.white,
          border: Colors.white24,
          chipBg: Color(0x33E94057),
          chipText: Colors.white,
          accent: _primary,
        ),
      ],
    );
  }

  static ThemeData light() {
    const bg = Color(0xFFF6F7FB);
    const surface = Colors.white;
    const surfaceAlt = Color(0xFFF0F2F7);

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: false,
      scaffoldBackgroundColor: bg,
      primaryColor: _primary,
      colorScheme: const ColorScheme.light(
        primary: _primary,
        secondary: _secondary,
        surface: surface,
        background: bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE3E6EE)),
        ),
      ),
      extensions: const [
        AppColors(
          background: bg,
          surface: surface,
          surfaceAlt: surfaceAlt,
          onBackground: Colors.black,
          onSurface: Colors.black,
          border: Color(0xFFE3E6EE),
          chipBg: Color(0x14E94057),
          chipText: Color(0xFFE94057),
          accent: _primary,
        ),
      ],
    );
  }
}

class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color onBackground;
  final Color onSurface;
  final Color border;
  final Color chipBg;
  final Color chipText;
  final Color accent;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.onBackground,
    required this.onSurface,
    required this.border,
    required this.chipBg,
    required this.chipText,
    required this.accent,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? onBackground,
    Color? onSurface,
    Color? border,
    Color? chipBg,
    Color? chipText,
    Color? accent,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      border: border ?? this.border,
      chipBg: chipBg ?? this.chipBg,
      chipText: chipText ?? this.chipText,
      accent: accent ?? this.accent,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      chipText: Color.lerp(chipText, other.chipText, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
