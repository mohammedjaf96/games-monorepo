import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';
import '../../theme/surfaceTone.dart';
import '../bouncyButton.dart';
import '../mascotMood.dart';
import '../mascotWidget.dart';

/// A first-launch "how to play" card shown once per game, before the very
/// first round: the mascot plus one goal sentence and one controls
/// sentence, dismissed with a single button. Closes the "what do I
/// actually do here?" gap new players hit with no onboarding at all.
class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key, required this.game, required this.goal, required this.controls, required this.onGotIt});

  final String game;
  final String goal;
  final String controls;
  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.gapHuge),
        decoration: stickerDecoration(fill: surfaceTone(Pal.cream), radius: AppSizes.radiusPanel, border: BorderWidths.thick, drop: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MascotWidget(mood: MascotMood.happy, game: game),
            const SizedBox(height: AppSizes.gapMedium),
            Text('labelHowToPlay'.tr, style: AppText.title()),
            const SizedBox(height: AppSizes.gapSmall),
            Text(goal, style: AppText.body(), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.gapExtraSmall),
            Text(controls, style: AppText.label(color: Pal.orange), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.gapLarge),
            BouncyButton(label: 'menuGotIt'.tr, fill: Pal.green, onPressed: onGotIt),
          ],
        ),
      ),
    );
  }
}
