import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'dashyGame.dart';

/// The static ground strip Dashy runs on (GAME_IDEAS.md §5.2).
class GroundComponent extends PositionComponent with HasGameReference<DashyGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(game.size.x, DashyGame.groundHeight);
    position = Vector2(0, game.size.y - DashyGame.groundHeight);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFF3ED367));
    canvas.drawLine(
      Offset.zero,
      Offset(size.x, 0),
      Paint()
        ..color = const Color(0xFF141428)
        ..strokeWidth = 4,
    );
  }
}
