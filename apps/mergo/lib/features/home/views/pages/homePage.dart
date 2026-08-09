import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
              WalletBar(onTapPlus: controller.shopTapped).animate().fadeIn(duration: 400.ms).moveY(begin: -16, end: 0),
              const Spacer(),
              MascotWidget(game: 'mergo', size: 110)
                  .animate(onPlay: (animationController) => animationController.repeat(reverse: true))
                  .moveY(begin: 0, end: -10, duration: 700.ms),
              const SizedBox(height: AppSizes.gapLarge),
              const OutlinedText('MERGO', size: 36, fill: Colors.white, shadow: Pal.orange)
                  .animate()
                  .scale(delay: 100.ms, duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: AppSizes.gapLarge),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapLarge, vertical: AppSizes.gapSmall),
                  decoration: stickerDecoration(
                    fill: surfaceTone(Colors.white),
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
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const Spacer(),
              BouncyButton(label: 'menuPlay'.tr, fill: Pal.yellow, onPressed: controller.playTapped)
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              const SizedBox(height: AppSizes.gapLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StickerIconButton(
                    iconAsset: 'assets/icons/shop.svg',
                    fill: surfaceTone(Colors.white),
                    onPressed: controller.shopTapped,
                  ).animate().fadeIn(delay: 500.ms, duration: 350.ms).moveY(begin: 16, end: 0),
                  const SizedBox(width: AppSizes.gapMedium),
                  StickerIconButton(
                    iconAsset: 'assets/icons/chest.svg',
                    fill: surfaceTone(Colors.white),
                    onPressed: controller.dailyRewardTapped,
                  ).animate().fadeIn(delay: 560.ms, duration: 350.ms).moveY(begin: 16, end: 0),
                  const SizedBox(width: AppSizes.gapMedium),
                  StickerIconButton(
                    iconAsset: 'assets/icons/gear.svg',
                    fill: surfaceTone(Colors.white),
                    onPressed: controller.settingsTapped,
                  ).animate().fadeIn(delay: 620.ms, duration: 350.ms).moveY(begin: 16, end: 0),
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
