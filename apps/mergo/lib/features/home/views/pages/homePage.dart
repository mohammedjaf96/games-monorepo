import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/homeController.dart';

/// Mergo's Home screen — "Clean Hero" style: one large hero tile, generous
/// whitespace (GAME_IDEAS.md §6.0/§6.3).
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ads = Get.find<AdService>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenMargin),
          child: Column(
            children: [
              WalletBar(onTapPlus: controller.shopTapped),
              const Spacer(),
              const MascotWidget(game: 'mergo', size: 110),
              const SizedBox(height: AppSizes.gapLarge),
              const OutlinedText('MERGO', size: 36, fill: Colors.white, shadow: Pal.orange),
              const SizedBox(height: AppSizes.gapLarge),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapLarge, vertical: AppSizes.gapSmall),
                  decoration: stickerDecoration(
                    fill: Colors.white,
                    radius: AppSizes.radiusChip,
                    border: BorderWidths.thin,
                    drop: 3,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/trophy.svg', package: 'game_core', width: 18, height: 18),
                      const SizedBox(width: AppSizes.gapExtraSmall),
                      Text('${controller.best.value}', style: AppText.label()),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              BouncyButton(label: 'menuPlay'.tr, fill: Pal.yellow, onPressed: controller.playTapped),
              const SizedBox(height: AppSizes.gapLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StickerIconButton(
                    iconAsset: 'assets/icons/shop.svg',
                    fill: Colors.white,
                    onPressed: controller.shopTapped,
                  ),
                  const SizedBox(width: AppSizes.gapMedium),
                  StickerIconButton(
                    iconAsset: 'assets/icons/gear.svg',
                    fill: Colors.white,
                    onPressed: controller.settingsTapped,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.gapMedium),
              ads.bannerWidget(placement: 'home'),
            ],
          ),
        ),
      ),
    );
  }
}
