import 'dart:ui';

import 'package:flame/components.dart';

import 'dashyGame.dart';
import 'dashyTrailSample.dart';

/// A short trail of fading dots behind the ball that lengthens and spreads
/// out as the run speeds up (GAME_IDEAS.md §5.8 "juice"): samples of the
/// player's recent position drift left at the world's scroll speed and
/// shrink/fade with age, reading as motion intensity for free.
class DashyTrail extends PositionComponent with HasGameReference<DashyGame> {
  DashyTrail() : super(priority: -1);

  static const double sampleInterval = 0.02;
  static const double maxAge = 0.35;

  double sampleTimer = 0;
  final List<DashyTrailSample> samples = [];

  @override
  void update(double dt) {
    super.update(dt);
    for (final sample in samples) {
      sample.age += dt;
    }
    samples.removeWhere((sample) => sample.age > maxAge);

    sampleTimer += dt;
    if (sampleTimer >= sampleInterval) {
      sampleTimer = 0;
      final player = game.player;
      samples.add(DashyTrailSample(x: player.position.x, y: player.position.y - player.height / 2, age: 0));
    }
  }

  @override
  void render(Canvas canvas) {
    if (samples.isEmpty) return;
    final speedFactor = (game.speed / DashyGame.baseSpeed).clamp(1.0, 2.8);
    for (final sample in samples) {
      final t = sample.age / maxAge;
      final dx = sample.x - sample.age * game.speed * speedFactor;
      final radius = 9 * (1 - t);
      if (radius <= 0) continue;
      canvas.drawCircle(
        Offset(dx, sample.y),
        radius,
        Paint()..color = const Color(0xFFFF7A2E).withOpacity((1 - t) * 0.4),
      );
    }
  }

  void reset() => samples.clear();
}
