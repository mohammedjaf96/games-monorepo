import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/appSizes.dart';
import '../theme/appText.dart';
import '../theme/borderWidths.dart';
import '../theme/pal.dart';
import '../theme/stickerDecoration.dart';
import 'bouncyButton.dart';
import 'settings/settingsController.dart';
import 'settings/stickerToggle.dart';

/// The shared in-game pause dialog: Resume / Restart / Home / Sound
/// (GAME_IDEAS.md §4.3/§5.3/§6.3).
class PauseDialog extends StatelessWidget {
  const PauseDialog({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onHome,
  });

  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.gapHuge),
        decoration: stickerDecoration(
          fill: Pal.cream,
          radius: AppSizes.radiusPanel,
          border: BorderWidths.thick,
          drop: 6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('menuResume'.tr, style: AppText.title()),
            const SizedBox(height: AppSizes.gapLarge),
            BouncyButton(label: 'menuResume'.tr, fill: Pal.green, onPressed: onResume),
            const SizedBox(height: AppSizes.gapSmall),
            BouncyButton(label: 'menuRestart'.tr, fill: Pal.yellow, onPressed: onRestart),
            const SizedBox(height: AppSizes.gapSmall),
            BouncyButton(label: 'menuHome'.tr, fill: Pal.blue, onPressed: onHome),
            const SizedBox(height: AppSizes.gapLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('labelSound'.tr, style: AppText.body()),
                const SizedBox(width: AppSizes.gapMedium),
                Obx(
                  () => StickerToggle(
                    value: settings.sound.value,
                    onChanged: (_) => settings.toggleSound(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
