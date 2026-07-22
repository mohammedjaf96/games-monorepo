import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

import '../../data/model/blockoColors.dart';
import '../../data/model/blockoPiece.dart';

/// Renders a piece's shape as a small grid of colored, outlined squares —
/// used for both the tray preview and the drag feedback (GAME_IDEAS.md §4.4).
class PieceShapeWidget extends StatelessWidget {
  const PieceShapeWidget({super.key, required this.piece, this.cellSize = 22});

  final BlockoPiece piece;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    final maxRow = piece.cells.map((cell) => cell.x).reduce((a, b) => a > b ? a : b);
    final maxCol = piece.cells.map((cell) => cell.y).reduce((a, b) => a > b ? a : b);
    final color = BlockoColors.palette[piece.colorIndex];
    return SizedBox(
      width: (maxCol + 1) * cellSize,
      height: (maxRow + 1) * cellSize,
      child: Stack(
        children: piece.cells.map((cell) {
          return Positioned(
            left: cell.y * cellSize,
            top: cell.x * cellSize,
            width: cellSize,
            height: cellSize,
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
