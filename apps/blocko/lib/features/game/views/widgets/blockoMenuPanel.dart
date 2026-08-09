import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonTokens.dart';
import '../../controllers/gameController.dart';
import 'blockoMenuRow.dart';

/// The hamburger's slide-out menu: Pause/Resume, Exit game, Sound,
/// Vibration — matching the "Neon Drop" reference's menu panel. Sound and
/// Vibration read/write the same shared `SettingsController` as every
/// other screen, so state stays in sync everywhere.
class BlockoMenuPanel extends StatelessWidget {
  const BlockoMenuPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final settings = Get.find<SettingsController>();
    final palette = BlockoNeonTokens.of(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: controller.toggleMenu,
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        Positioned(
          top: 64,
          left: 0,
          width: 216,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: palette.panelBackground,
              border: Border.all(color: palette.panelBorder),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: palette.boardOuterGlow, blurRadius: 24, offset: const Offset(0, 14))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => BlockoMenuRow(
                    label: controller.paused.value ? 'menuResume'.tr : 'menuPause'.tr,
                    color: palette.textPrimary,
                    dividerColor: palette.menuDivider,
                    onTap: controller.togglePause,
                  ),
                ),
                BlockoMenuRow(
                  label: 'menuExitGame'.tr,
                  color: const Color(0xFFFF5B7A),
                  dividerColor: palette.menuDivider,
                  onTap: controller.exitGame,
                ),
                Obx(
                  () => BlockoMenuRow(
                    label: 'labelSound'.tr,
                    value: settings.sound.value ? 'labelOn'.tr : 'labelOff'.tr,
                    color: palette.textPrimary,
                    valueColor: palette.textSecondary,
                    dividerColor: palette.menuDivider,
                    onTap: settings.toggleSound,
                  ),
                ),
                Obx(
                  () => BlockoMenuRow(
                    label: 'labelVibration'.tr,
                    value: settings.vibration.value ? 'labelOn'.tr : 'labelOff'.tr,
                    color: palette.textPrimary,
                    valueColor: palette.textSecondary,
                    onTap: settings.toggleVibration,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
