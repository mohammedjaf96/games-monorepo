import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/homeController.dart';
import '../widgets/boardPreviewWidget.dart';

/// Blocko's Home screen — "Candy Squishy" style (GAME_IDEAS.md §4.0/§4.3).
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
              const SizedBox(height: AppSizes.gapMedium),
              const OutlinedText('BLOCKO', size: 34, fill: Colors.white),
              const SizedBox(height: AppSizes.gapMedium),
              const Expanded(child: BoardPreviewWidget()),
              const SizedBox(height: AppSizes.gapMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MascotWidget(game: 'blocko', size: 64),
                  const SizedBox(width: AppSizes.gapMedium),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapLarge, vertical: AppSizes.gapSmall),
                      decoration: stickerDecoration(
                        fill: Pal.yellow,
                        radius: AppSizes.radiusChip,
                        border: BorderWidths.thin,
                        drop: 3,
                      ),
                      child: Text('${'labelBest'.tr}: ${controller.best.value}', style: AppText.label()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.gapLarge),
              BouncyButton(label: 'menuPlay'.tr, fill: Pal.green, onPressed: controller.playTapped),
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
