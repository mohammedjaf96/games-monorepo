import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/routing/appRoutes.dart';
import '../../controllers/gameController.dart';
import '../widgets/boardWidget.dart';

/// Blocko's gameplay screen: score header, the falling-block well, and a
/// rotate button. Left/right movement is a swipe gesture anywhere on
/// screen, not a fixed control (GAME_IDEAS.md §4.3).
class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => EdgeGlowWidget(
          trigger: controller.glowTrigger.value,
          big: controller.glowBig.value,
          hotColor: const Color(0xFFEAF9FF),
          primaryColor: GameTheme.blocko.primary,
          deepColor: GameTheme.blocko.backgroundEnd,
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) => controller.handleSwipeDelta(details.delta.dx),
              onPanEnd: (_) => controller.resetSwipeAccumulator(),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.screenMargin),
                child: Obx(
                  () => ShakeWidget(
                    trigger: controller.shakeTrigger.value,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Obx(() => AnimatedCounter(value: controller.score.value, style: AppText.heroNumber())),
                                const Spacer(),
                                Obx(() => Text('${'labelBest'.tr}: ${controller.best.value}', style: AppText.body())),
                                const SizedBox(width: AppSizes.gapMedium),
                                StickerIconButton(
                                  iconAsset: 'assets/icons/gear.svg',
                                  fill: Colors.white,
                                  onPressed: () => Get.dialog(
                                    PauseDialog(
                                      onResume: Get.back,
                                      onRestart: () {
                                        Get.back();
                                        controller.restart();
                                      },
                                      onHome: () => Get.offAllNamed(AppRoutes.home),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.gapLarge),
                            const Expanded(child: BoardWidget()),
                            const SizedBox(height: AppSizes.gapLarge),
                            Center(
                              child: StickerIconButton(iconAsset: 'assets/icons/rotate.svg', fill: Colors.white, onPressed: controller.rotate),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Obx(() => FloatingScoreTextOverlay(entries: controller.floatingTexts)),
                        ),
                        Positioned.fill(
                          child: Obx(() => ParticleBurstOverlay(bursts: controller.bursts)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
