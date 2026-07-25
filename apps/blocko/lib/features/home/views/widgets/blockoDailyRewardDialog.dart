import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoDialogButton.dart';

/// Blocko's own "Neon Drop"-styled Daily Reward popup — reuses the shared
/// `DailyRewardService` (the 7-day streak logic is identical across every
/// game) but replaces the cutesy cream dialog with neon panels.
class BlockoDailyRewardDialog extends StatelessWidget {
  const BlockoDailyRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Get.find<DailyRewardService>();
    final palette = BlockoNeonTokens.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: palette.panelBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.panelBorder),
            boxShadow: [BoxShadow(color: palette.boardOuterGlow, blurRadius: 30, spreadRadius: 2)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'labelDailyReward'.tr.toUpperCase(),
                style: BlockoNeonText.overlayTitle(color: palette.textPrimary, size: 20).copyWith(
                  shadows: [Shadow(color: palette.scoreGlow, blurRadius: 14)],
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final currentDay = service.currentDay;
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  runSpacing: 8,
                  children: List.generate(service.config.days.length, (index) {
                    final dayNumber = index + 1;
                    final claimed = dayNumber < currentDay;
                    final isToday = dayNumber == currentDay;
                    final active = claimed || isToday;
                    return Container(
                      width: 36,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active ? palette.scoreColor : Colors.transparent,
                        border: Border.all(color: active ? palette.scoreColor : palette.panelBorder),
                        boxShadow: isToday ? [BoxShadow(color: palette.scoreGlow, blurRadius: 10)] : const [],
                      ),
                      child: Text(
                        claimed ? '✓' : '$dayNumber',
                        style: BlockoNeonText.body(color: active ? const Color(0xFF0A0713) : palette.textSecondary),
                      ),
                    );
                  }),
                );
              }),
              const SizedBox(height: 22),
              Obx(
                () => BlockoDialogButton(
                  label: '${'goClaim'.tr} ${service.pendingReward.gems}',
                  color: palette.scoreColor,
                  filled: true,
                  onTap: service.canClaimToday
                      ? () async {
                          await service.claim();
                          Get.back();
                        }
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              BlockoDialogButton(
                label: 'goDoubleGems'.tr,
                color: palette.titleGlow,
                filled: false,
                onTap: () async {
                  await service.claim(doubled: true);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
