import 'package:flutter/widgets.dart';

/// One theme's worth of Blocko's "Neon Drop" tokens — exact color/glow
/// values for either the night or day variant.
class BlockoNeonPalette {
  const BlockoNeonPalette({
    required this.backgroundGradient,
    required this.boardBackground,
    required this.boardBorder,
    required this.boardOuterGlow,
    required this.boardInnerGlow,
    required this.gridLine,
    required this.panelBackground,
    required this.panelBorder,
    required this.menuDivider,
    required this.textPrimary,
    required this.textSecondary,
    required this.hamburgerColor,
    required this.hamburgerGlow,
    required this.titleGlow,
    required this.scoreColor,
    required this.scoreGlow,
  });

  final Gradient backgroundGradient;
  final Gradient boardBackground;
  final Color boardBorder;
  final Color boardOuterGlow;
  final Color boardInnerGlow;
  final Color gridLine;
  final Color panelBackground;
  final Color panelBorder;
  final Color menuDivider;
  final Color textPrimary;
  final Color textSecondary;
  final Color hamburgerColor;
  final Color hamburgerGlow;
  final Color titleGlow;
  final Color scoreColor;
  final Color scoreGlow;
}
