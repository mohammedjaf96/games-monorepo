import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// The unified border/outline (and default ink/text) color used on every
/// sticker-style element — dark navy in light mode, a light near-white in
/// dark mode so borders and text stay legible against a dark background.
class OutlineColor {
  static Color get color => Get.isDarkMode ? const Color(0xFFEDEFFA) : const Color(0xFF141428);
}
