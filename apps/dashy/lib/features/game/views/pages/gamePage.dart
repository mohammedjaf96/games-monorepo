import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import '../widgets/hudWidget.dart';

/// Dashy's gameplay screen: the Flame game widget plus a Flutter HUD overlay
/// (GAME_IDEAS.md §5.3/§5.9).
class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ShakeWidget(
          trigger: controller.shakeTrigger.value,
          child: Stack(
            children: [
              Positioned.fill(child: GameWidget(game: controller.game)),
              Positioned.fill(child: Obx(() => ParticleBurstOverlay(bursts: controller.bursts))),
              SafeArea(child: HudWidget(onPause: controller.openPauseMenu)),
            ],
          ),
        ),
      ),
    );
  }
}
