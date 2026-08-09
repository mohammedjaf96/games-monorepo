import 'package:flutter/material.dart';

/// Paints a soft, blurred glow that hugs only the very edges of its bounds
/// and fades toward the center — the "Siri activation ring" look, recolored
/// to the game's own brand colors. Used by [EdgeGlowWidget].
class EdgeGlowPainter extends CustomPainter {
  EdgeGlowPainter({required this.intensity, required this.big, required this.hotColor, required this.primaryColor, required this.deepColor});

  final double intensity;
  final bool big;
  final Color hotColor;
  final Color primaryColor;
  final Color deepColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;
    final scale = big ? 1.4 : 1.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final deepWidth = 30.0 * scale;
    final deepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = deepWidth
      ..color = deepColor.withOpacity(0.5 * intensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 28.0 * scale);
    canvas.drawRect(rect.deflate(deepWidth / 2), deepPaint);

    final primaryWidth = 14.0 * scale;
    final primaryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = primaryWidth
      ..color = primaryColor.withOpacity(0.75 * intensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 16.0 * scale);
    canvas.drawRect(rect.deflate(primaryWidth / 2), primaryPaint);

    final hotWidth = 6.0 * scale;
    final hotPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = hotWidth
      ..color = hotColor.withOpacity(0.9 * intensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 * scale);
    canvas.drawRect(rect.deflate(hotWidth / 2), hotPaint);
  }

  @override
  bool shouldRepaint(covariant EdgeGlowPainter oldDelegate) => oldDelegate.intensity != intensity || oldDelegate.big != big;
}
