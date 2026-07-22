import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'coinComponent.dart';
import 'dashyGame.dart';
import 'obstacleComponent.dart';

/// Dashy the ball: automatic forward motion is implied by the scrolling
/// world; this component only owns jump physics (GAME_IDEAS.md §5.1/§5.2).
class DashyPlayer extends PositionComponent with CollisionCallbacks, HasGameReference<DashyGame> {
  DashyPlayer() : super(size: Vector2(44, 44), anchor: Anchor.bottomCenter);

  static const double gravity = 1800;
  static const double jumpVelocity = -620;

  double velocityY = 0;
  bool isOnGround = true;
  bool isDead = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(RectangleHitbox());
    position = Vector2(80, groundY());
  }

  double groundY() => game.size.y - DashyGame.groundHeight;

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    velocityY += gravity * dt;
    position.y += velocityY * dt;
    final floor = groundY();
    if (position.y >= floor) {
      position.y = floor;
      velocityY = 0;
      isOnGround = true;
    } else {
      isOnGround = false;
    }
  }

  void jump() {
    if (!isOnGround || isDead) return;
    velocityY = jumpVelocity;
    isOnGround = false;
  }

  void reset() {
    isDead = false;
    velocityY = 0;
    position = Vector2(80, groundY());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (isDead) return;
    if (other is ObstacleComponent) {
      if (game.consumeShieldIfActive()) {
        other.removeFromParent();
        return;
      }
      isDead = true;
      game.registerDeath();
    } else if (other is CoinComponent) {
      other.removeFromParent();
      game.registerCoinCollected();
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.shieldActive) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(size.toRect().inflate(6), const Radius.circular(18)),
        Paint()
          ..color = const Color(0xFF37B6FF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
    final rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(14));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFFFF7A2E));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFF141428)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }
}
