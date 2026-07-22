import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';

/// The in-game HUD: distance + coins + pause (GAME_IDEAS.md §5.3).
class HudWidget extends StatelessWidget {
  const HudWidget({super.key, required this.onPause});

  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Padding(
      padding: const EdgeInsets.all(AppSizes.screenMargin),
      child: Row(
        children: [
          Obx(
            () => Text(
              '${controller.distance.value.floor()}m',
              style: AppText.heroNumber(color: Colors.white),
            ),
          ),
          const SizedBox(width: AppSizes.gapMedium),
          Obx(
            () => Row(
              children: [
                SvgPicture.asset('assets/icons/coin.svg', package: 'game_core', width: 18, height: 18),
                const SizedBox(width: AppSizes.gapExtraSmall),
                Text('${controller.coins.value}', style: AppText.body(color: Colors.white)),
              ],
            ),
          ),
          const Spacer(),
          StickerIconButton(iconAsset: 'assets/icons/gear.svg', fill: Colors.white, onPressed: onPause),
        ],
      ),
    );
  }
}
