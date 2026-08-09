import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'dashyGame.dart';

/// A ground spike/crate obstacle that scrolls left at the current run speed
/// (GAME_IDEAS.md §5.2).
class ObstacleComponent extends PositionComponent with CollisionCallbacks, HasGameReference<DashyGame> {
  ObstacleComponent({required Vector2 position})
      : super(position: position, size: Vector2(30, 44), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.speed * dt;
    if (position.x + size.x < 0) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFFFF4D3D));
    canvas.drawRect(
      size.toRect(),
      Paint()
        ..color = const Color(0xFF141428)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
