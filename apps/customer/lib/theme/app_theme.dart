import 'package:flutter/material.dart';

class AppFonts {
  /// Poppins for English; a Sinhala / Tamil face for those languages, with
  /// Poppins still drawing digits and Latin letters inside them.
  static String family = 'Poppins';
  static List<String> fallback = const ['NotoSansSinhala', 'NotoSansTamil'];

  /// True for Sinhala and Tamil: no tight letter-spacing, a little more line height.
  static bool indic = false;

  static void apply(String languageCode) {
    indic = languageCode == 'si' || languageCode == 'ta';
    switch (languageCode) {
      case 'si':
        family = 'NotoSansSinhala';
        fallback = const ['Poppins', 'NotoSansTamil'];
      case 'ta':
        family = 'NotoSansTamil';
        fallback = const ['Poppins', 'NotoSansSinhala'];
      default:
        family = 'Poppins';
        fallback = const ['NotoSansSinhala', 'NotoSansTamil'];
    }
  }
}

/// One set of brand colours (light or dark mode).
class AppPalette {
  const AppPalette({
    required this.brightness,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.line,
    required this.surface,
    required this.background,
    required this.yellowSoft,
    required this.yellowDeep,
    required this.solid,
    required this.danger,
    required this.success,
    required this.info,
  });

  final Brightness brightness;
  final Color ink;
  final Color inkSoft;
  final Color muted;
  final Color line;
  final Color surface;
  final Color background;
  final Color yellowSoft;
  final Color yellowDeep;
  final Color solid;
  final Color danger;
  final Color success;
  final Color info;

  static const light = AppPalette(
    brightness: Brightness.light,
    ink: Color(0xFF111111),
    inkSoft: Color(0xFF3D3D3A),
    muted: Color(0xFF73726C),
    line: Color(0xFFECEBE6),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF8F8F6),
    yellowSoft: Color(0xFFFFF3D0),
    yellowDeep: Color(0xFFE09A00),
    solid: Color(0xFF111111),
    danger: Color(0xFFD92D20),
    success: Color(0xFF1F8A4C),
    info: Color(0xFF2A78D6),
  );

  static const dark = AppPalette(
    brightness: Brightness.dark,
    ink: Color(0xFFF2F1EC),
    inkSoft: Color(0xFFC9C8C1),
    muted: Color(0xFF9D9C95),
    line: Color(0xFF2F2F2B),
    surface: Color(0xFF1C1C1A),
    background: Color(0xFF121211),
    yellowSoft: Color(0xFF3A3114),
    yellowDeep: Color(0xFFFFC21A),
    solid: Color(0xFF2C2C29),
    danger: Color(0xFFFF6B5E),
    success: Color(0xFF4CC27A),
    info: Color(0xFF6AA6F0),
  );
}

/// RepairMe brand colours for the current mode (see [AppColors.apply]).
///
/// [ink] is the main text/icon colour; [solid] is the dark fill behind white
/// or yellow content (job code card, own chat bubbles, dark pills). Content on
/// yellow always uses [black].
class AppColors {
  static AppPalette _palette = AppPalette.light;

  static void apply(Brightness brightness) =>
      _palette = brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;

  static bool get isDark => _palette.brightness == Brightness.dark;

  static const yellow = Color(0xFFFFC21A);
  static const black = Color(0xFF111111);

  static Color get ink => _palette.ink;
  static Color get inkSoft => _palette.inkSoft;
  static Color get muted => _palette.muted;
  static Color get line => _palette.line;
  static Color get surface => _palette.surface;
  static Color get background => _palette.background;

  /// Pale yellow tint behind icons and notes.
  static Color get yellowSoft => _palette.yellowSoft;

  /// Yellow for text and icons on surfaces, where [yellow] is too light to read.
  static Color get yellowDeep => _palette.yellowDeep;
  static Color get solid => _palette.solid;
  static Color get danger => _palette.danger;
  static Color get success => _palette.success;
  static Color get info => _palette.info;
}

/// The theme for [brightness]; call [AppColors.apply] with it first.
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.yellow,
    brightness: brightness,
    primary: dark ? AppColors.yellow : AppColors.ink,
    onPrimary: dark ? AppColors.black : Colors.white,
    secondary: AppColors.yellow,
    onSecondary: AppColors.black,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    error: AppColors.danger,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: AppFonts.family,
    fontFamilyFallback: AppFonts.fallback,
  );
  final text = base.textTheme.apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
    heightFactor: AppFonts.indic ? 1.2 : 1.0,
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: AppFonts.indic ? 0 : -0.6),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: AppFonts.indic ? 0 : -0.4),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.family, fontFamilyFallback: AppFonts.fallback,
        color: AppColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: dark ? AppColors.yellow : AppColors.ink,
        foregroundColor: dark ? AppColors.black : Colors.white,
        disabledForegroundColor: AppColors.muted,
        disabledBackgroundColor: AppColors.line,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(fontFamily: AppFonts.family, fontFamilyFallback: AppFonts.fallback, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: AppColors.line, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(fontFamily: AppFonts.family, fontFamilyFallback: AppFonts.fallback, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ink,
        textStyle: TextStyle(fontFamily: AppFonts.family, fontFamilyFallback: AppFonts.fallback, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.ink, width: 1.6),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.yellow,
      side: BorderSide(color: AppColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: TextStyle(fontFamily: AppFonts.family, fontFamilyFallback: AppFonts.fallback, color: AppColors.ink, fontWeight: FontWeight.w500),
      showCheckmark: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: AppColors.line),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      elevation: 0,
      height: 70,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 24,
          color: states.contains(WidgetState.selected) ? AppColors.yellowDeep : AppColors.muted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontFamily: AppFonts.family, fontFamilyFallback: AppFonts.fallback,
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? AppColors.ink : AppColors.muted,
        ),
      ),
    ),
    dividerTheme: DividerThemeData(color: AppColors.line, thickness: 1, space: 1),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
