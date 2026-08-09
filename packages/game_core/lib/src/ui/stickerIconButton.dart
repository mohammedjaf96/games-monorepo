import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../audio/audioService.dart';
import '../audio/hapticPattern.dart';
import '../audio/hapticsService.dart';
import '../theme/appSizes.dart';
import '../theme/borderWidths.dart';
import '../theme/stickerDecoration.dart';

/// A 44x44 rounded-square icon button using a custom SVG icon (never emoji)
/// from `game_core/assets/icons/` (GAME_IDEAS.md §3.14.4-b/§3.14.7).
class StickerIconButton extends StatelessWidget {
  StickerIconButton({
    super.key,
    required this.iconAsset,
    required this.fill,
    required this.onPressed,
    this.size = AppSizes.iconButtonSize,
  });

  final String iconAsset;
  final Color fill;
  final VoidCallback? onPressed;
  final double size;

  final RxBool pressed = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onPressed == null ? null : (_) => pressed.value = true,
      onTapUp: onPressed == null ? null : (_) => pressed.value = false,
      onTapCancel: onPressed == null ? null : () => pressed.value = false,
      onTap: onPressed == null
          ? null
          : () {
              Get.find<HapticsService>().pulse(HapticPattern.light);
              Get.find<AudioService>().playSfx('button');
              onPressed!();
            },
      child: Obx(
        () => AnimatedScale(
          scale: pressed.value ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: stickerDecoration(
              fill: fill,
              radius: 12,
              border: BorderWidths.thin,
              drop: pressed.value ? 2 : 4,
            ),
            child: SvgPicture.asset(
              iconAsset,
              package: 'game_core',
              width: AppSizes.iconSize,
              height: AppSizes.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
