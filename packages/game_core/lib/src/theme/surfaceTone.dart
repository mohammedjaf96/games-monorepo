import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Darkens a light "chrome" surface color (panels, cards, dialogs, empty
/// board cells) for dark mode by blending it toward the app's own ink
/// color, so every neutral surface adapts automatically without needing a
/// hand-picked dark variant. Brand/accent colors (buttons, gameplay piece
/// colors) should stay constant and never pass through this.
Color surfaceTone(Color light) {
  if (!Get.isDarkMode) return light;
  return Color.lerp(light, const Color(0xFF0B0A16), 0.62)!;
}
