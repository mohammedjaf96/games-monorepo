import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoDialogButton.dart';
import '../../../../core/widgets/blockoNeonIconButton.dart';
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.radiusChip),
                          color: palette.panelBackground,
                          border: Border.all(color: palette.panelBorder),
                          boxShadow: [BoxShadow(color: palette.hamburgerGlow, blurRadius: 10)],
                        ),
                        child: Text(
                          '${'labelBest'.tr}: ${controller.best.value}',
                          style: BlockoNeonText.menuItem(color: palette.textPrimary),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  ],
                ),
                const SizedBox(height: AppSizes.gapLarge),
                BlockoDialogButton(label: 'menuPlay'.tr, color: palette.scoreColor, filled: true, onTap: controller.playTapped)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                const SizedBox(height: AppSizes.gapLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlockoNeonIconButton(
                      iconAsset: 'assets/icons/shop.svg',
                      onPressed: controller.shopTapped,
                    ).animate().fadeIn(delay: 500.ms, duration: 350.ms).moveY(begin: 16, end: 0),
                    const SizedBox(width: AppSizes.gapMedium),
                    BlockoNeonIconButton(
                      iconAsset: 'assets/icons/chest.svg',
                      onPressed: controller.dailyRewardTapped,
                    ).animate().fadeIn(delay: 560.ms, duration: 350.ms).moveY(begin: 16, end: 0),
                    const SizedBox(width: AppSizes.gapMedium),
                    BlockoNeonIconButton(
                      iconAsset: 'assets/icons/gear.svg',
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
