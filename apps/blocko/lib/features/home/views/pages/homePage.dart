import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../controllers/homeController.dart';
import '../widgets/boardPreviewWidget.dart';

/// Blocko's Home screen, in the same "Neon Drop" look as the gameplay
/// screen (GAME_IDEAS.md §4.0/§4.3).
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ads = Get.find<AdService>();
    final palette = BlockoNeonTokens.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: palette.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.screenMargin),
            child: Column(
              children: [
                WalletBar(onTapPlus: controller.shopTapped).animate().fadeIn(duration: 400.ms).moveY(begin: -16, end: 0),
                const SizedBox(height: AppSizes.gapMedium),
                Text(
                  'BLOCKO',
                  style: BlockoNeonText.title(color: palette.scoreColor).copyWith(
                    fontSize: 34,
                    shadows: [
                      Shadow(color: palette.titleGlow, blurRadius: 14),
                      Shadow(color: palette.scoreGlow, blurRadius: 26),
                    ],
                  ),
                ).animate().scale(delay: 100.ms, duration: 500.ms, curve: Curves.elasticOut),
                const SizedBox(height: AppSizes.gapMedium),
                const Expanded(child: BoardPreviewWidget()),
                const SizedBox(height: AppSizes.gapMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MascotWidget(game: 'blocko', size: 64)
                        .animate(onPlay: (animationController) => animationController.repeat(reverse: true))
                        .moveY(begin: 0, end: -8, duration: 700.ms),
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
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  ],
                ),
                const SizedBox(height: AppSizes.gapLarge),
                BouncyButton(label: 'menuPlay'.tr, fill: Pal.green, onPressed: controller.playTapped)
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
      ),
    );
  }
}
