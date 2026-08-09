import 'dart:ui';

import 'package:flame/components.dart';

import 'dashyGame.dart';

/// A midground scrolling hill silhouette behind the ground, giving the
/// runner a sense of depth (GAME_IDEAS.md §5.9 "parallax"). Scrolls slower
/// than the foreground so it reads as farther away.
class DashyHillLayer extends PositionComponent with HasGameReference<DashyGame> {
  DashyHillLayer() : super(priority: -2);

  static const double parallaxFactor = 0.35;
  static const double repeatWidth = 260;
  static const double hillHeight = 60;

  double offset = 0;

  @override
  void update(double dt) {
    super.update(dt);
    offset = (offset + game.speed * parallaxFactor * dt) % repeatWidth;
  }

  @override
  void render(Canvas canvas) {
    final baseY = game.size.y - DashyGame.groundHeight;
    final paint = Paint()..color = const Color(0xFF2FBF5A);
    for (var x = -repeatWidth - offset; x < game.size.x + repeatWidth; x += repeatWidth) {
      final path = Path()
        ..moveTo(x, baseY)
        ..quadraticBezierTo(x + repeatWidth / 2, baseY - hillHeight, x + repeatWidth, baseY)
        ..lineTo(x + repeatWidth, baseY + hillHeight)
        ..lineTo(x, baseY + hillHeight)
        ..close();
      canvas.drawPath(path, paint);
    }
  }
}
