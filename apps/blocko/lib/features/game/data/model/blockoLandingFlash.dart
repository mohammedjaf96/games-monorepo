/// One "piece just landed" flash event: which board cells to glow under,
/// tagged with a unique id so the board can remove it once its animation
/// finishes.
class BlockoLandingFlash {
  const BlockoLandingFlash({required this.id, required this.cellIndexes});

  final int id;
  final List<int> cellIndexes;
}
