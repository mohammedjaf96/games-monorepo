import 'package:flutter/material.dart';

import 'blockoShapeType.dart';

/// Each falling shape has one fixed, distinctive color, index-matched to
/// `BlockoShapeType`'s declaration order. Vivid, high-saturation set chosen
/// for eye appeal over the earlier muted `Pal` picks.
class BlockoColors {
  static const List<Color> palette = [
    Color(0xFF00D9FF), // rectangle: electric cyan
    Color(0xFFFFDE59), // square: vivid lemon-gold
    Color(0xFFFF7A00), // cornerL: vivid tangerine
    Color(0xFFB026FF), // cornerT: electric violet
    Color(0xFFFF2E63), // dot: hot crimson-pink
  ];

  static Color colorFor(BlockoShapeType type) => palette[type.index];
}
