import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../store/cosmetic.dart';
import '../../store/storeController.dart';
import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/outlineColor.dart';
import '../../theme/pal.dart';
import '../../theme/surfaceTone.dart';
import '../rewardedButton.dart';

/// Shown when a purchase is blocked by an insufficient gem balance
/// (GAME_IDEAS.md §3.11.7-e). Watching an ad earns the first configured gem
/// pack and returns the player to finish their purchase.
class EarnGemsSheet extends StatelessWidget {
  const EarnGemsSheet({super.key, required this.target});

  final Cosmetic target;

  @override
  Widget build(BuildContext context) {
    final store = Get.find<StoreController>();
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapHuge),
      decoration: BoxDecoration(
        color: surfaceTone(Pal.cream),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusPanel)),
        border: Border.all(color: OutlineColor.color, width: BorderWidths.thick),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('labelInsufficientGems'.tr, style: AppText.title()),
          const SizedBox(height: AppSizes.gapMedium),
          Text('labelEarnGems'.tr, style: AppText.body()),
          const SizedBox(height: AppSizes.gapLarge),
          if (store.economyConfig.gemPacks.isNotEmpty)
            RewardedButton(
              label: '${'goWatchAd'.tr} +${store.economyConfig.gemPacks.first.amount}',
              onPressed: () => store.claimGemPack(store.economyConfig.gemPacks.first),
            ),
        ],
      ),
    );
  }
}
