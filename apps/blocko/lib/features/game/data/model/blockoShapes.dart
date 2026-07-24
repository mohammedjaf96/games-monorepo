import 'dart:math';

import 'blockoShapeType.dart';

/// Each shape's base cells (`x` = row, `y` = column) inside its own square
/// bounding box, plus the box size used to rotate it. Rotation is computed
/// generically — see [BlockoShapes.cellsFor] — instead of hand-listing four
/// states per shape.
class BlockoShapes {
  static const Map<BlockoShapeType, int> boxSize = {
    BlockoShapeType.rectangle: 4,
    BlockoShapeType.square: 2,
    BlockoShapeType.cornerL: 3,
    BlockoShapeType.cornerT: 3,
    BlockoShapeType.dot: 1,
  };

  static const Map<BlockoShapeType, List<Point<int>>> baseCells = {
    BlockoShapeType.rectangle: [Point(1, 0), Point(1, 1), Point(1, 2), Point(1, 3)],
    BlockoShapeType.square: [Point(0, 0), Point(0, 1), Point(1, 0), Point(1, 1)],
    BlockoShapeType.cornerL: [Point(0, 0), Point(1, 0), Point(2, 0), Point(2, 1)],
    BlockoShapeType.cornerT: [Point(0, 1), Point(1, 0), Point(1, 1), Point(1, 2)],
    BlockoShapeType.dot: [Point(0, 0)],
  };

  /// The shape's cells at `rotation` (0-3), rotated 90° clockwise per step
  /// within its bounding box. List order is stable across rotation, so a
  /// UI can key each cell by index and animate it smoothly between states.
  static List<Point<int>> cellsFor(BlockoShapeType type, int rotation) {
    final n = boxSize[type]!;
    var cells = baseCells[type]!;
    for (var step = 0; step < rotation % 4; step++) {
      cells = cells.map((cell) => Point(cell.y, n - 1 - cell.x)).toList();
    }
    return cells;
  }
}
