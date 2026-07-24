import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

import 'blockoShapeType.dart';

/// Each falling shape has one fixed, distinctive color, index-matched to
/// `BlockoShapeType`'s declaration order.
class BlockoColors {
  static const List<Color> palette = [Pal.blue, Pal.yellow, Pal.orange, Pal.purple, Pal.red];

  static Color colorFor(BlockoShapeType type) => palette[type.index];
}
