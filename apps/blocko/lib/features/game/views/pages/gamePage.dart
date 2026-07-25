import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonTokens.dart';
import '../../controllers/gameController.dart';
import '../widgets/blockoGameTopBar.dart';
import '../widgets/blockoMenuPanel.dart';
import '../widgets/blockoPausedOverlay.dart';
import '../widgets/boardWidget.dart';

/// Blocko's gameplay screen: the "Neon Drop"-styled top bar (hamburger menu,
/// pulsing wordmark, lightning-bolt score), the falling-block well, and a
/// rotate button. Left/right movement is a swipe gesture anywhere on screen,
/// not a fixed control (GAME_IDEAS.md §4.3). The day/night toggle lives on
/// the Settings screen, not here.
class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: palette.backgroundGradient),
        child: Obx(() {
          debugPrint('DEBUGTRACE edgeGlowObx read');
          return EdgeGlowWidget(
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
                  child: Obx(() {
                    debugPrint('DEBUGTRACE shakeObx read');
                    return ShakeWidget(
                      trigger: controller.shakeTrigger.value,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const BlockoGameTopBar(),
                              const SizedBox(height: AppSizes.gapLarge),
                              const Expanded(child: BoardWidget()),
                              const SizedBox(height: AppSizes.gapLarge),
                              Center(
                                child: StickerIconButton(iconAsset: 'assets/icons/rotate.svg', fill: surfaceTone(Colors.white), onPressed: controller.rotate),
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
                          Obx(() {
                            debugPrint('DEBUGTRACE pausedObx read=${controller.paused.value}');
                            return controller.paused.value ? const Positioned.fill(child: BlockoPausedOverlay()) : const SizedBox.shrink();
                          }),
                          Obx(() {
                            debugPrint('DEBUGTRACE menuOpenObx read=${controller.menuOpen.value}');
                            return controller.menuOpen.value ? const Positioned.fill(child: BlockoMenuPanel()) : const SizedBox.shrink();
                          }),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
