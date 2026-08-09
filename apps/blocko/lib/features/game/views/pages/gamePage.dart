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
/// pulsing wordmark, lightning-bolt score) and the falling-block well, which
/// is the sole control surface — tap anywhere on it to rotate, drag
/// left/right to move, drag down to fast-drop (GAME_IDEAS.md §4.3). The
/// day/night toggle lives on the Settings screen, not here.
class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: palette.backgroundGradient),
        child: Obx(
          () => EdgeGlowWidget(
            trigger: controller.glowTrigger.value,
            big: controller.glowBig.value,
            hotColor: const Color(0xFFEAF9FF),
            primaryColor: palette.scoreColor,
            deepColor: palette.titleGlow,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.screenMargin),
                child: Obx(
                  () => ShakeWidget(
                    trigger: controller.shakeTrigger.value,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const BlockoGameTopBar(),
                            const SizedBox(height: AppSizes.gapLarge),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: controller.rotateFromTap,
                                onPanUpdate: (details) => controller.handlePanUpdate(details.delta),
                                onPanEnd: (_) => controller.handlePanEnd(),
                                child: const BoardWidget(),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Obx(() => FloatingScoreTextOverlay(entries: controller.floatingTexts.toList())),
                        ),
                        Positioned.fill(
                          child: Obx(() => ParticleBurstOverlay(bursts: controller.bursts.toList())),
                        ),
                        Obx(() => controller.paused.value ? const Positioned.fill(child: BlockoPausedOverlay()) : const SizedBox.shrink()),
                        Obx(() => controller.menuOpen.value ? const Positioned.fill(child: BlockoMenuPanel()) : const SizedBox.shrink()),
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
