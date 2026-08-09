import 'package:flutter/material.dart';

/// Paints the faint cell-grid lines behind the board, matching the "Neon
/// Drop" reference's `background-image` grid pattern.
class BlockoGridPainter extends CustomPainter {
  const BlockoGridPainter({required this.cellSize, required this.lineColor});

  final double cellSize;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant BlockoGridPainter oldDelegate) =>
      oldDelegate.cellSize != cellSize || oldDelegate.lineColor != lineColor;
}
