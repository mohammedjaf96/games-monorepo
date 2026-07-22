import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'coinComponent.dart';
import 'dashyPlayer.dart';
import 'groundComponent.dart';
import 'obstacleComponent.dart';
import 'obstacleSpawner.dart';

/// The Flame game loop for Dashy's endless runner (GAME_IDEAS.md §5.9).
/// GetX-side state (distance/coins/best) lives in `GameController`, which
/// owns this instance and reacts to its callbacks.
class DashyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  DashyGame({required this.onScore, required this.onCoin, required this.onDeath});

  final void Function(double distance) onScore;
  final void Function() onCoin;
  final void Function() onDeath;

  static const double groundHeight = 90;
  static const double baseSpeed = 220;
  static const double maxSpeed = 620;

  late final DashyPlayer player;
  late final ObstacleSpawner spawner;

  double speed = baseSpeed;
  double distance = 0;
  bool shieldActive = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(GroundComponent());
    player = DashyPlayer();
    await add(player);
    spawner = ObstacleSpawner();
    await add(spawner);
  }

  @override
  void update(double dt) {
    super.update(dt);
    distance += speed * dt / 40;
    speed = (baseSpeed + distance * 1.2).clamp(baseSpeed, maxSpeed);
    onScore(distance);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
  }

  void registerCoinCollected() => onCoin();

  void registerDeath() {
    pauseEngine();
    onDeath();
  }

  /// Grants a shield that absorbs the run's first collision (GAME_IDEAS.md §5.7).
  void activateShield() {
    shieldActive = true;
  }

  /// Consumes the shield if one is active. Returns true if a collision was absorbed.
  bool consumeShieldIfActive() {
    if (!shieldActive) return false;
    shieldActive = false;
    return true;
  }

  /// Revive in place: clear obstacles and resume the same run (distance,
  /// coins, and speed are preserved) — GAME_IDEAS.md §5.7.
  void reviveInPlace() {
    children.whereType<ObstacleComponent>().toList().forEach((c) => c.removeFromParent());
    children.whereType<CoinComponent>().toList().forEach((c) => c.removeFromParent());
    player.reset();
    resumeEngine();
  }

  /// Full reset for Retry.
  void reset() {
    distance = 0;
    speed = baseSpeed;
    shieldActive = false;
    children.whereType<ObstacleComponent>().toList().forEach((c) => c.removeFromParent());
    children.whereType<CoinComponent>().toList().forEach((c) => c.removeFromParent());
    player.reset();
    resumeEngine();
  }
}
