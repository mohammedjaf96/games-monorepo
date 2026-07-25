import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../theme/blockoNeonTokens.dart';

/// A neon-panel icon button (Home screen's shop/daily-reward/settings
/// row) — the "Neon Drop" equivalent of the shared cutesy
/// `StickerIconButton` used by the other games, styled like the gameplay
/// screen's hamburger button.
class BlockoNeonIconButton extends StatelessWidget {
  const BlockoNeonIconButton({super.key, required this.iconAsset, required this.onPressed});

  final String iconAsset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return GestureDetector(
      onTap: () {
        Get.find<HapticsService>().pulse(HapticPattern.light);
        Get.find<AudioService>().playSfx('button');
        onPressed();
      },
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: palette.panelBackground,
          border: Border.all(color: palette.panelBorder),
          boxShadow: [BoxShadow(color: palette.hamburgerGlow, blurRadius: 12)],
        ),
        child: SvgPicture.asset(iconAsset, package: 'game_core', width: 22, height: 22),
      ),
    );
  }
}
