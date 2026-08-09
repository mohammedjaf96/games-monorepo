import 'dart:ui';

import 'package:flame/components.dart';

import 'dashyGame.dart';

/// The farthest scrolling parallax layer: soft clouds that barely react to
/// speed, reading as distant sky (GAME_IDEAS.md §5.9).
class DashyCloudLayer extends PositionComponent with HasGameReference<DashyGame> {
  DashyCloudLayer() : super(priority: -3);

  static const double parallaxFactor = 0.08;
  static const double repeatWidth = 340;

  double offset = 0;

  @override
  void update(double dt) {
    super.update(dt);
    offset = (offset + game.speed * parallaxFactor * dt) % repeatWidth;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0x33FFFFFF);
    for (var x = -repeatWidth - offset; x < game.size.x + repeatWidth; x += repeatWidth) {
      canvas.drawOval(Rect.fromLTWH(x, 60, 90, 34), paint);
      canvas.drawOval(Rect.fromLTWH(x + 50, 44, 70, 30), paint);
      canvas.drawOval(Rect.fromLTWH(x + 180, 90, 80, 28), paint);
    }
  }
}
