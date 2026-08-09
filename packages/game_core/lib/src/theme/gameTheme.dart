import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gamePalette.dart';
import 'pal.dart';

/// Builds light/dark [ThemeData] pairs from a game's [GamePalette]
/// (GAME_IDEAS.md §3.9/§3.14.8). Only the background adapts here — every
/// other surface (dialogs, panels, cards) darkens itself individually via
/// `surfaceTone()`, and ink/borders via `OutlineColor.color`.
class GameTheme {
  static const GamePalette blocko = GamePalette(
    primary: Color(0xFF3D5CFF),
    secondary: Color(0xFFFF2E63),
    accents: [Color(0xFF00E5A8), Color(0xFFFFDE59), Color(0xFFB026FF)],
    background: Color(0xFF3D5CFF),
    backgroundEnd: Color(0xFF7B2FFF),
    backgroundDark: Color(0xFF0A0618),
    panel: Color(0xFFF3F6FF),
    surface: Color(0xFFF3F6FF),
    primaryCta: Color(0xFF00E5A8),
    splashStart: Color(0xFF3D5CFF),
    splashEnd: Color(0xFF7B2FFF),
  );

  static const GamePalette dashy = GamePalette(
    primary: Color(0xFF7C3AED),
    secondary: Pal.pink,
    accents: [Pal.yellow, Pal.orange],
    background: Color(0xFF7C3AED),
    backgroundEnd: Color(0xFF4C1D95),
    panel: Color(0xFF2A1856),
    surface: Color(0xFF2A1856),
    primaryCta: Pal.yellow,
    splashStart: Color(0xFF7C3AED),
    splashEnd: Color(0xFF4C1D95),
  );

  static const GamePalette mergo = GamePalette(
    primary: Pal.teal,
    secondary: Pal.orange,
    accents: [Pal.yellow, Pal.purple],
    background: Pal.teal,
    backgroundEnd: Color(0xFF0A6E62),
    panel: Pal.cream,
    surface: Pal.cream,
    primaryCta: Pal.yellow,
    splashStart: Pal.teal,
    splashEnd: Color(0xFF0A6E62),
  );

  /// Blends `color` toward a near-black ink so any light background reads
  /// as a moody dark one, without needing a hand-picked dark variant.
  static Color darken(Color color) => Color.lerp(color, const Color(0xFF0B0A16), 0.62)!;

  static ThemeData light(GamePalette palette) => buildFor(palette, Brightness.light);

  static ThemeData dark(GamePalette palette) => buildFor(palette, Brightness.dark);

  static ThemeData buildFor(GamePalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? (palette.backgroundDark ?? darken(palette.background)) : palette.background,
      textTheme: GoogleFonts.baloo2TextTheme(isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: brightness,
        primary: palette.primary,
        secondary: palette.secondary,
      ),
    );
  }
}
