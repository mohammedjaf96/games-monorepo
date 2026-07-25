import 'package:flutter/material.dart';

import 'blockoNeonPalette.dart';

/// The two "Neon Drop" themes Blocko ships — night and day — plus a lookup
/// that follows the app's existing light/dark [ThemeMode] (set from
/// Settings, GAME_IDEAS.md §3.16), so no separate in-game toggle is needed.
class BlockoNeonTokens {
  static const BlockoNeonPalette night = BlockoNeonPalette(
    backgroundGradient: RadialGradient(
      center: Alignment(-0.4, -1),
      radius: 1.2,
      colors: [Color(0xFF1A0B33), Color(0xFF0A0713), Color(0xFF050308)],
      stops: [0, 0.45, 1],
    ),
    boardBackground: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0D0817), Color(0xFF07050D)],
    ),
    boardBorder: Color(0x59966AFF),
    boardOuterGlow: Color(0x59783CFF),
    boardInnerGlow: Color(0x99000000),
    gridLine: Color(0x0DFFFFFF),
    panelBackground: Color(0xF0140D22),
    panelBorder: Color(0x66A06EFF),
    menuDivider: Color(0x14FFFFFF),
    textPrimary: Color(0xFFF3ECFF),
    textSecondary: Color(0x8CE6DCFF),
    hamburgerColor: Color(0xFFE8DDFF),
    hamburgerGlow: Color(0x66966AFF),
    titleGlow: Color(0xCCB478FF),
    scoreColor: Color(0xFFCCFF00),
    scoreGlow: Color(0xBFCCFF00),
  );

  static const BlockoNeonPalette day = BlockoNeonPalette(
    backgroundGradient: RadialGradient(
      center: Alignment(-0.4, -1),
      radius: 1.2,
      colors: [Color(0xFFBCD9FF), Color(0xFF7FA6E8), Color(0xFF5678C9)],
      stops: [0, 0.55, 1],
    ),
    boardBackground: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFEEF3FF), Color(0xFFD3DEF7)],
    ),
    boardBorder: Color(0x663C50AA),
    boardOuterGlow: Color(0x403C50AA),
    boardInnerGlow: Color(0x1F3C50AA),
    gridLine: Color(0x121E285A),
    panelBackground: Color(0xF2FFFFFF),
    panelBorder: Color(0x4D3C50AA),
    menuDivider: Color(0x14141432),
    textPrimary: Color(0xFF181832),
    textSecondary: Color(0x8C141432),
    hamburgerColor: Color(0xFF1C1C3A),
    hamburgerGlow: Color(0x403C50AA),
    titleGlow: Color(0x995A3CC8),
    scoreColor: Color(0xFF8A00D4),
    scoreGlow: Color(0x8C8A00D4),
  );

  static BlockoNeonPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? night : day;
}
