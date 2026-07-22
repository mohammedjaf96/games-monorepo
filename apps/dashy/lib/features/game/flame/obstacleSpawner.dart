import 'dart:math';

import 'package:flame/components.dart';

import 'coinComponent.dart';
import 'dashyGame.dart';
import 'obstacleComponent.dart';

/// Spawns obstacles (and occasional coins) with a time-based gap that grows
/// with the current speed, so a jump always has room to clear the next
/// obstacle (GAME_IDEAS.md §5.5).
class ObstacleSpawner extends Component with HasGameReference<DashyGame> {
  double timeSinceLastSpawn = 0;
  final Random random = Random();

  @override
  void update(double dt) {
    super.update(dt);
    timeSinceLastSpawn += dt;
    final requiredGapSeconds = 1.1 + random.nextDouble() * 0.8;
    if (timeSinceLastSpawn >= requiredGapSeconds) {
      timeSinceLastSpawn = 0;
      spawnObstacle();
    }
  }

  void spawnObstacle() {
    final spawnX = game.size.x + 40;
    final groundY = game.size.y - DashyGame.groundHeight;
    game.add(ObstacleComponent(position: Vector2(spawnX, groundY)));
    if (random.nextDouble() < 0.6) {
      game.add(CoinComponent(position: Vector2(spawnX + 60, groundY - 70)));
    }
  }
}
