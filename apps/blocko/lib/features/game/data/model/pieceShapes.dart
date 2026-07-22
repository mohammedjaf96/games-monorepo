import 'dart:math';

/// The fixed catalog of piece shapes (1x1 up to L/T/S/Z) — no rotation
/// (GAME_IDEAS.md §4.2).
class PieceShapes {
  static const List<List<Point<int>>> all = [
    [Point(0, 0)],
    [Point(0, 0), Point(0, 1)],
    [Point(0, 0), Point(0, 1), Point(0, 2)],
    [Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3)],
    [Point(0, 0), Point(1, 0)],
    [Point(0, 0), Point(1, 0), Point(2, 0)],
    [Point(0, 0), Point(0, 1), Point(1, 0), Point(1, 1)],
    [Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 0), Point(1, 1), Point(1, 2)],
    [Point(0, 0), Point(1, 0), Point(2, 0), Point(2, 1)],
    [Point(0, 1), Point(1, 1), Point(2, 1), Point(2, 0)],
    [Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 1)],
    [Point(0, 1), Point(0, 2), Point(1, 0), Point(1, 1)],
    [Point(0, 0), Point(0, 1), Point(1, 1), Point(1, 2)],
    [Point(0, 0), Point(0, 1), Point(1, 0)],
  ];

  static List<List<Point<int>>> smallShapes() => all.where((shape) => shape.length <= 3).toList();
}
