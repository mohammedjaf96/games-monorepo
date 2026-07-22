import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gamePalette.dart';
import 'pal.dart';

/// Builds a Flutter [ThemeData] from a game's [GamePalette] (GAME_IDEAS.md §3.9/§3.14.8).
class GameTheme {
  static const GamePalette blocko = GamePalette(
    primary: Pal.blue,
    secondary: Pal.red,
    accents: [Pal.green, Pal.yellow, Pal.purple],
    background: Pal.blue,
    backgroundEnd: Color(0xFF1B4FD8),
    panel: Pal.cream,
    surface: Color(0xFFF5E4BE),
    primaryCta: Pal.green,
    splashStart: Pal.blue,
    splashEnd: Color(0xFF1B4FD8),
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

  static ThemeData build(GamePalette palette) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      textTheme: GoogleFonts.baloo2TextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        primary: palette.primary,
        secondary: palette.secondary,
      ),
    );
  }
}
