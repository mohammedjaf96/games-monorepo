import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../controllers/gameController.dart';

/// The full-board "PAUSED" overlay shown while `GameController.paused` is
/// true, matching the "Neon Drop" reference.
class BlockoPausedOverlay extends StatelessWidget {
  const BlockoPausedOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final palette = BlockoNeonTokens.of(context);
    return Container(
      color: const Color(0xB8040208),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'labelPaused'.tr.toUpperCase(),
              style: BlockoNeonText.overlayTitle(color: Colors.white).copyWith(
                shadows: [Shadow(color: palette.scoreGlow, blurRadius: 16)],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: controller.togglePause,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: palette.scoreColor),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('menuResume'.tr.toUpperCase(), style: BlockoNeonText.overlayButton(color: palette.scoreColor)),
            ),
          ],
        ),
      ),
    );
  }
}
