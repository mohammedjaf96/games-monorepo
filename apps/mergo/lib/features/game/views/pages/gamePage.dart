import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/routing/appRoutes.dart';
import '../../controllers/gameController.dart';
import '../widgets/gridWidget.dart';

/// Mergo's gameplay screen: score header, grid, undo/hammer, pause
/// (GAME_IDEAS.md §6.3).
class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            fill: surfaceTone(Colors.white),
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
                      const Expanded(child: GridWidget()),
                      const SizedBox(height: AppSizes.gapLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RewardedButton(label: 'goUndo'.tr, onPressed: controller.undo),
                          const SizedBox(width: AppSizes.gapMedium),
                          RewardedButton(label: 'goHammer'.tr, onPressed: controller.activateHammer, fill: Pal.orange),
                        ],
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
    );
  }
}
