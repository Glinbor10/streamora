import 'package:material_ui/material_ui.dart';

/// Visual identity of streamora: navy blue surfaces with an electric cyan
/// accent.
abstract final class AppColors {
  /// App background.
  static const background = Color(0xFF0A1128);

  /// Raised surfaces (cards, bars).
  static const surface = Color(0xFF121C3D);

  /// Higher surfaces (chips, inputs).
  static const surfaceHigh = Color(0xFF1B2750);

  /// Brand accent.
  static const accent = Color(0xFF3DD6F5);

  /// Text drawn on top of the accent.
  static const onAccent = Color(0xFF06101F);

  /// Primary text.
  static const text = Color(0xFFF4F7FF);

  /// Secondary text.
  static const textMuted = Color(0xFF8FA0C8);

  /// Semantic red used only for the LIVE badge.
  static const live = Color(0xFFFF4D5E);
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
          onPrimary: AppColors.onAccent,
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
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          minimumSize: const Size(48, 48),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          minimumSize: const Size(48, 48),
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.surfaceHigh, width: 1.5),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.accent,
        labelStyle: base.textTheme.labelLarge?.copyWith(color: AppColors.text),
        secondaryLabelStyle: base.textTheme.labelLarge?.copyWith(
          color: AppColors.onAccent,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: const TextStyle(color: AppColors.text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
