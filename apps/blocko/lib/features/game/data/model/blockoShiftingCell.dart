/// One settled block sliding down after a row clear, from its old grid
/// index to its new one, as part of the same gravity-collapse event.
class BlockoShiftingCell {
  const BlockoShiftingCell({required this.fromIndex, required this.toIndex, required this.colorValue});

  final int fromIndex;
  final int toIndex;
  final int colorValue;
}
