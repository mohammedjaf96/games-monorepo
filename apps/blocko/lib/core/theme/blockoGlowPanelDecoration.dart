import 'package:flutter/material.dart';

import 'blockoNeonPalette.dart';

/// The soft, blurred "neon panel" recipe shared by the board, the board
/// preview, and the slide-out menu — a glowing border instead of the rest
/// of the app's hard-edged sticker shadow (`stickerDecoration`).
BoxDecoration blockoGlowPanelDecoration({
  required BlockoNeonPalette palette,
  required Gradient background,
  double radius = 14,
}) {
  return BoxDecoration(
    gradient: background,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: palette.boardBorder),
    boxShadow: [
      BoxShadow(color: palette.boardOuterGlow, blurRadius: 30, spreadRadius: 2),
      BoxShadow(color: palette.boardInnerGlow, blurRadius: 40, spreadRadius: -10),
    ],
  );
}
