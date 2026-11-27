import 'package:material_ui/material_ui.dart';

/// Visual identity of streamora: dark, cinematic, one red accent.
abstract final class AppColors {
  /// App background.
  static const background = Color(0xFF0B0B0F);

  /// Raised surfaces (cards, rails).
  static const surface = Color(0xFF15151C);

  /// Higher surfaces (chips, inputs).
  static const surfaceHigh = Color(0xFF1F1F29);

  /// Brand accent.
  static const accent = Color(0xFFE50914);

  /// Primary text.
  static const text = Color(0xFFF5F5F7);

  /// Secondary text.
  static const textMuted = Color(0xFFA1A1AA);
}

/// Builds the app [ThemeData].
abstract final class AppTheme {
  /// The only theme: dark by design.
  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.accent,
          surface: AppColors.surface,
          onSurface: AppColors.text,
        );
    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accent.withValues(alpha: 0.25),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accent.withValues(alpha: 0.25),
        selectedIconTheme: const IconThemeData(color: AppColors.text),
        unselectedIconTheme: const IconThemeData(color: AppColors.textMuted),
        selectedLabelTextStyle: base.textTheme.labelMedium?.copyWith(
          color: AppColors.text,
        ),
        unselectedLabelTextStyle: base.textTheme.labelMedium?.copyWith(
          color: AppColors.textMuted,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceHigh,
        selectedColor: AppColors.accent,
        labelStyle: base.textTheme.labelLarge?.copyWith(color: AppColors.text),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
