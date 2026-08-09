import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import 'dashyGame.dart';

/// Foreground streak lines that only appear once the run is fast, and get
/// denser/brighter the faster it goes (GAME_IDEAS.md §5.8 "juice"):
/// reinforces velocity purely visually, with no extra UI.
class DashySpeedLines extends PositionComponent with HasGameReference<DashyGame> {
  DashySpeedLines() : super(priority: 10);

  static const int laneCount = 6;
  static const double activationRatio = 0.25;

  final Random random = Random();
  final List<double> laneY = [];
  final List<double> laneX = [];
  final List<double> laneLength = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for (var i = 0; i < laneCount; i++) {
      laneY.add(random.nextDouble() * game.size.y * 0.7);
      laneX.add(random.nextDouble() * game.size.x);
      laneLength.add(30 + random.nextDouble() * 40);
    }
  }

  double speedRatio() => ((game.speed - DashyGame.baseSpeed) / (DashyGame.maxSpeed - DashyGame.baseSpeed)).clamp(0.0, 1.0);

  @override
  void update(double dt) {
    super.update(dt);
    if (speedRatio() <= activationRatio) return;
    for (var i = 0; i < laneCount; i++) {
      laneX[i] -= game.speed * (1.4 + i * 0.1) * dt;
      if (laneX[i] + laneLength[i] < 0) {
        laneX[i] = game.size.x + random.nextDouble() * 60;
        laneY[i] = random.nextDouble() * game.size.y * 0.7;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final ratio = speedRatio();
    if (ratio <= activationRatio) return;
    final intensity = (ratio - activationRatio) / (1 - activationRatio);
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(intensity * 0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < laneCount; i++) {
      canvas.drawLine(Offset(laneX[i], laneY[i]), Offset(laneX[i] + laneLength[i], laneY[i]), paint);
    }
  }
}
