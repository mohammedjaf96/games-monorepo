import 'dart:math';

/// A draggable piece: a set of relative cell offsets (`x` = row, `y` = column)
/// plus a color index into the block palette (GAME_IDEAS.md §4.2).
class BlockoPiece {
  const BlockoPiece({required this.id, required this.cells, required this.colorIndex});

  final String id;
  final List<Point<int>> cells;
  final int colorIndex;
}
