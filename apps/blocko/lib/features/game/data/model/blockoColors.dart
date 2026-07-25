import 'package:flutter/material.dart';

import 'blockoShapeType.dart';

/// Each falling shape has one fixed, distinctive color, index-matched to
/// `BlockoShapeType`'s declaration order. Matches the "Neon Drop" reference
/// design's exact piece palette.
class BlockoColors {
  static const List<Color> palette = [
    Color(0xFF00E5FF), // rectangle: electric cyan
    Color(0xFFFFD400), // square: neon gold
    Color(0xFFFF7A00), // cornerL: neon tangerine
    Color(0xFFB026FF), // cornerT: electric violet
    Color(0xFFFF2BD6), // dot: neon pink
  ];

  static Color colorFor(BlockoShapeType type) => palette[type.index];
}
