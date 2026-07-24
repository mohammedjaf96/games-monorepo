import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../audio/audioService.dart';
import '../audio/hapticPattern.dart';
import '../audio/hapticsService.dart';
import '../theme/appSizes.dart';
import '../theme/appText.dart';
import '../theme/borderWidths.dart';
import '../theme/outlineColor.dart';
import '../theme/stickerDecoration.dart';

/// A sticker-style button: thick dark border + solid drop shadow, scales
/// down and drops its shadow offset on press (GAME_IDEAS.md §3.14.3).
class BouncyButton extends StatelessWidget {
  BouncyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fill = const Color(0xFF3ED367),
    Color? textColor,
    this.height = AppSizes.primaryButtonHeight,
    this.icon,
  }) : textColor = textColor ?? OutlineColor.color;

  final String label;
  final VoidCallback? onPressed;
  final Color fill;
  final Color textColor;
  final double height;
  final Widget? icon;

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
              Get.find<AudioService>().playSfx('tap');
              onPressed!();
            },
      child: Obx(
        () => AnimatedScale(
          scale: pressed.value ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapHuge),
            decoration: stickerDecoration(
              fill: onPressed == null ? fill.withOpacity(0.5) : fill,
              radius: AppSizes.radiusButton,
              border: BorderWidths.thick,
              drop: pressed.value ? 2 : BorderWidths.heavy,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: AppSizes.gapSmall)],
                Text(label.toUpperCase(), style: AppText.buttonLabel(color: textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
