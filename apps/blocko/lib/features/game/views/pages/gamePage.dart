import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/routing/appRoutes.dart';
import '../../controllers/gameController.dart';
import '../widgets/boardWidget.dart';
import '../widgets/pieceTrayWidget.dart';

/// Blocko's gameplay screen: score header, board, tray, pause
/// (GAME_IDEAS.md §4.3).
class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenMargin),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Obx(() => Text('${controller.score.value}', style: AppText.heroNumber())),
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
                  const PieceTrayWidget(),
                  const SizedBox(height: AppSizes.gapMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => StickerIconButton(
                          iconAsset: 'assets/icons/undo.svg',
                          fill: controller.canUndo.value ? Colors.white : Colors.white.withOpacity(0.4),
                          onPressed: controller.canUndo.value ? () => controller.undo() : null,
                        ),
                      ),
                      const SizedBox(width: AppSizes.gapMedium),
                      StickerIconButton(
                        iconAsset: 'assets/icons/bomb.svg',
                        fill: Colors.white,
                        onPressed: () => controller.refreshPieces(),
                      ),
                    ],
                  ),
                ],
              ),
              Obx(() {
                final text = controller.floatingText.value;
                if (text == null) return const SizedBox.shrink();
                return Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(text, style: AppText.title(color: Pal.orange)),
                  ),
                );
              }),
              Positioned.fill(
                child: Obx(() => ParticleBurstOverlay(bursts: controller.bursts)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
