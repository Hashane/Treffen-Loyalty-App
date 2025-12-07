import 'package:flutter/material.dart';

class AppTheme {
  // Light theme using a seed color to generate a ColorScheme
  static ThemeData light({bool useMaterial3 = true}) {
    // - Primary: Navy Blue
    // - Secondary: Teal Accent
    // - Background / Surface: soft greys
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0B3D91), // navy
      secondary: const Color(0xFF17A2B8), // teal
      brightness: Brightness.light,
    );

    final base = ThemeData.from(
      colorScheme: colorScheme,
      textTheme: Typography.material2018(platform: TargetPlatform.android).black,
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF6F8FA),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface.withValues(alpha: 0.98),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Optional dark theme
  static ThemeData dark({bool useMaterial3 = true}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0B3D91),
      brightness: Brightness.dark,
    );

    final base = ThemeData.from(colorScheme: colorScheme);
    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}

// Example of a ThemeExtension for brand values (optional)
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  final Color? highlight;

  const BrandColors({this.highlight});

  @override
  BrandColors copyWith({Color? highlight}) => BrandColors(highlight: highlight ?? this.highlight);

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(highlight: Color.lerp(highlight, other.highlight, t));
  }
}
