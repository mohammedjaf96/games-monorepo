import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

/// The tile color ladder rising with the tile's value (GAME_IDEAS.md §6.8).
class MergoTileColors {
  static const Map<int, Color> byValue = {
    2: Pal.blue,
    4: Pal.green,
    8: Pal.yellow,
    16: Pal.orange,
    32: Pal.red,
  };

  static Color colorFor(int value) => byValue[value] ?? Pal.purple;
}
