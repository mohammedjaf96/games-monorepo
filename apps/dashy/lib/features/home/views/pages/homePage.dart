import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/homeController.dart';
import '../widgets/framedMascotWidget.dart';

/// Dashy's Home screen — "Clash-style HUD" (GAME_IDEAS.md §5.0/§5.3).
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
              const OutlinedText('DASHY', size: 36, fill: Colors.white, shadow: Pal.pink),
              const SizedBox(height: AppSizes.gapLarge),
              const FramedMascotWidget(),
              const SizedBox(height: AppSizes.gapLarge),
              Text('labelTapToPlay'.tr, style: AppText.body(color: Colors.white)),
              const SizedBox(height: AppSizes.gapSmall),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapLarge, vertical: AppSizes.gapSmall),
                  decoration: stickerDecoration(
                    fill: const Color(0xFF2A1856),
                    radius: AppSizes.radiusChip,
                    border: BorderWidths.thin,
                    drop: 3,
                  ),
                  child: Text(
                    '${'labelBest'.tr}: ${controller.best.value}m',
                    style: AppText.label(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapMedium),
              Obx(
                () => controller.shieldPending.value
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapLarge, vertical: AppSizes.gapSmall),
                        decoration: stickerDecoration(
                          fill: Pal.blue,
                          radius: AppSizes.radiusChip,
                          border: BorderWidths.thin,
                          drop: 2,
                        ),
                        child: Text('labelShieldReady'.tr, style: AppText.label(color: Colors.white)),
                      )
                    : RewardedButton(label: 'goShield'.tr, onPressed: controller.activateShield, fill: Pal.blue),
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
                    iconAsset: 'assets/icons/chest.svg',
                    fill: Colors.white,
                    onPressed: controller.dailyRewardTapped,
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
