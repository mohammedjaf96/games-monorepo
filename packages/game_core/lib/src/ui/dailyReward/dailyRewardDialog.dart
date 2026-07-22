import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../economy/dailyReward/dailyRewardService.dart';
import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';
import '../bouncyButton.dart';
import '../rewardedButton.dart';

/// The 7-day streak dialog shown once per new calendar day (GAME_IDEAS.md §3.12.3).
class DailyRewardDialog extends StatelessWidget {
  const DailyRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Get.find<DailyRewardService>();
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
            Text('labelDailyReward'.tr, style: AppText.title()),
            const SizedBox(height: AppSizes.gapLarge),
            Obx(() {
              final currentDay = service.currentDay;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(service.config.days.length, (index) {
                  final dayNumber = index + 1;
                  final claimed = dayNumber < currentDay;
                  final isToday = dayNumber == currentDay;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 36,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: stickerDecoration(
                        fill: claimed
                            ? Pal.green
                            : isToday
                                ? Pal.yellow
                                : Colors.white,
                        radius: 10,
                        border: BorderWidths.thin,
                        drop: isToday ? 4 : 2,
                      ),
                      child: Text(
                        claimed ? '✓' : '$dayNumber',
                        style: AppText.caption(),
                      ),
                    ),
                  );
                }),
              );
            }),
            const SizedBox(height: AppSizes.gapLarge),
            Obx(
              () => BouncyButton(
                label: '${'goClaim'.tr} ${service.pendingReward.gems}',
                fill: Pal.green,
                icon: SvgPicture.asset('assets/icons/gem.svg', package: 'game_core', width: 16, height: 16),
                onPressed: service.canClaimToday
                    ? () async {
                        await service.claim();
                        Get.back();
                      }
                    : null,
              ),
            ),
            const SizedBox(height: AppSizes.gapSmall),
            RewardedButton(
              label: 'goDoubleGems'.tr,
              onPressed: () async {
                await service.claim(doubled: true);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
