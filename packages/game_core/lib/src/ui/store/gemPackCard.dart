import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../economy/gemPack.dart';
import '../../store/storeController.dart';
import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';
import '../rewardedButton.dart';

/// A gem pack in the store's Gems tab: a pile of gems + amount + a Watch
/// button (GAME_IDEAS.md §3.11.7-d).
class GemPackCard extends StatelessWidget {
  const GemPackCard({super.key, required this.pack});

  final GemPack pack;

  @override
  Widget build(BuildContext context) {
    final store = Get.find<StoreController>();
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapMedium),
      decoration: stickerDecoration(
        fill: Colors.white,
        radius: AppSizes.radiusCard,
        border: BorderWidths.thin,
        drop: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/gem.svg', package: 'game_core', width: 40, height: 40),
          const SizedBox(height: AppSizes.gapExtraSmall),
          Text('+${pack.amount}', style: AppText.title()),
          if (pack.badge != null) ...[
            const SizedBox(height: AppSizes.gapExtraSmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapSmall, vertical: 2),
              decoration: stickerDecoration(fill: Pal.yellow, radius: 8, border: BorderWidths.hairline, drop: 2),
              child: Text(pack.badge!, style: AppText.caption()),
            ),
          ],
          const SizedBox(height: AppSizes.gapSmall),
          RewardedButton(label: 'goWatchAd'.tr, onPressed: () => store.claimGemPack(pack)),
        ],
      ),
    );
  }
}
