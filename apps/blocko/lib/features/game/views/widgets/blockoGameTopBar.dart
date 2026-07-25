import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../controllers/gameController.dart';

/// The gameplay screen's top bar: a hamburger button that opens the
/// slide-out menu, and a pulsing-glow "BLOCKO" wordmark with a
/// lightning-bolt score readout — matching the "Neon Drop" reference.
/// No day/night control here; that toggle lives on the Settings screen.
class BlockoGameTopBar extends StatelessWidget {
  const BlockoGameTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final palette = BlockoNeonTokens.of(context);
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.toggleMenu,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: palette.panelBackground,
                border: Border.all(color: palette.panelBorder),
                boxShadow: [BoxShadow(color: palette.hamburgerGlow, blurRadius: 12)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(width: 18, height: 2, color: palette.hamburgerColor),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'BLOCKO',
                  style: BlockoNeonText.title(color: palette.scoreColor).copyWith(
                    shadows: [
                      Shadow(color: palette.titleGlow, blurRadius: 10),
                      Shadow(color: palette.scoreGlow, blurRadius: 20),
                    ],
                  ),
                ).animate(onPlay: (animationController) => animationController.repeat(reverse: true)).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.03, 1.03),
                      duration: 1600.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt, size: 15, color: palette.scoreColor, shadows: [Shadow(color: palette.scoreGlow, blurRadius: 6)]),
                    const SizedBox(width: 4),
                    Obx(() {
                      debugPrint('DEBUGTRACE scoreObx read=${controller.score.value}');
                      return AnimatedCounter(value: controller.score.value, style: BlockoNeonText.score(color: palette.scoreColor));
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
