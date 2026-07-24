import 'dart:ui';

import 'package:flame/components.dart';

import 'dashyGame.dart';

/// Static full-screen sky gradient — the backmost parallax layer
/// (GAME_IDEAS.md §5.9).
class DashySkyComponent extends PositionComponent with HasGameReference<DashyGame> {
  DashySkyComponent() : super(priority: -4);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = Gradient.linear(
          rect.topCenter,
          rect.bottomCenter,
          const [Color(0xFF37B6FF), Color(0xFFAEE7FF)],
        ),
    );
  }
}
