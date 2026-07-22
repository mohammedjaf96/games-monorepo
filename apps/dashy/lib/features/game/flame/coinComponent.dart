import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'dashyGame.dart';

/// A collectible coin that scrolls left at the current run speed
/// (GAME_IDEAS.md §5.2).
class CoinComponent extends PositionComponent with CollisionCallbacks, HasGameReference<DashyGame> {
  CoinComponent({required Vector2 position})
      : super(position: position, size: Vector2(22, 22), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.speed * dt;
    if (position.x + size.x < 0) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final radius = size.x / 2;
    final center = Offset(radius, radius);
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFFD028));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF141428)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
