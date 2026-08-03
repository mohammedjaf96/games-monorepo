import 'package:flutter/material.dart';

/// The scene's colours, and the reasoning behind the two that matter.
///
/// Amber and the deep navy are not decoration. The whole story is about a
/// warning light in a dark cabin, so the background has to be dark enough that
/// a single amber glow reads as *the* event on screen — and amber has to be
/// the only warm colour anywhere until the moment the diagnosis arrives.
abstract class ScenePalette {
  /// Night in a car, not black. Pure black kills the glow.
  static const Color night = Color(0xFF080B14);
  static const Color deep = Color(0xFF0E1424);

  /// The check-engine light. The first thing the eye finds, deliberately.
  static const Color amber = Color(0xFFFFA522);

  /// The product's own orange, kept apart from the warning amber so the two
  /// never read as the same signal.
  static const Color brand = Color(0xFFFF5722);

  static const Color cyan = Color(0xFF35D0E8);
  static const Color good = Color(0xFF3DDC97);
  static const Color danger = Color(0xFFFF4D5E);

  static const Color ink = Color(0xFFF3F5FA);
  static const Color muted = Color(0x99F3F5FA);
  static const Color faint = Color(0x33F3F5FA);

  /// A glow, done as a blurred stroke rather than a shadow.
  ///
  /// `MaskFilter.blur` on the paint costs one pass; a `BoxShadow` under a
  /// widget would need a second layer and cannot follow an arbitrary path.
  static Paint glow(Color color, double width, double blur) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

  static Paint stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static Paint fill(Color color) => Paint()..color = color;
}
