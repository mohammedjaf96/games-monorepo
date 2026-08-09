import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/appSizes.dart';
import '../theme/appText.dart';
import '../theme/borderWidths.dart';
import '../theme/pal.dart';
import '../theme/stickerDecoration.dart';
import '../theme/surfaceTone.dart';
import 'bouncyButton.dart';
import 'mascotMood.dart';
import 'mascotWidget.dart';
import 'rewardedButton.dart';

/// The shared end-of-round dialog every game shows via `GameSessionFlow`
/// (GAME_IDEAS.md §3.10). Purely presentational — all behavior is wired in
/// by the caller through these callbacks.
class GameOverDialog extends StatelessWidget {
  GameOverDialog({
    super.key,
    required this.game,
    required this.score,
    required this.best,
    required this.isNewRecord,
    required this.onRevive,
    required this.onDoubleCoins,
    required this.onRetry,
    required this.onHome,
  }) : confettiController = ConfettiController(duration: const Duration(seconds: 2)) {
    if (isNewRecord) confettiController.play();
  }

  final String game;
  final int score;
  final int best;
  final bool isNewRecord;
  final Future<void> Function()? onRevive;
  final Future<void> Function() onDoubleCoins;
  final Future<void> Function() onRetry;
  final Future<void> Function() onHome;
  final ConfettiController confettiController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.gapHuge),
            decoration: stickerDecoration(
              fill: surfaceTone(Pal.cream),
              radius: AppSizes.radiusPanel,
              border: BorderWidths.thick,
              drop: 6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MascotWidget(mood: isNewRecord ? MascotMood.happy : MascotMood.sad, game: game),
                const SizedBox(height: AppSizes.gapMedium),
                Text('labelGameOver'.tr, style: AppText.title()),
                const SizedBox(height: AppSizes.gapSmall),
                Text('$score', style: AppText.heroNumber()),
                const SizedBox(height: AppSizes.gapExtraSmall),
                Text(
                  isNewRecord ? 'labelNewRecord'.tr : '${'labelBest'.tr}: $best',
                  style: AppText.body(),
                ),
                const SizedBox(height: AppSizes.gapLarge),
                RewardedButton(label: 'goRevive'.tr, onPressed: onRevive),
                const SizedBox(height: AppSizes.gapSmall),
                RewardedButton(label: 'goDoubleCoins'.tr, onPressed: onDoubleCoins, fill: Pal.orange),
                const SizedBox(height: AppSizes.gapSmall),
                BouncyButton(label: 'menuRetry'.tr, fill: Pal.green, onPressed: () => onRetry()),
                const SizedBox(height: AppSizes.gapSmall),
                BouncyButton(label: 'menuHome'.tr, fill: Pal.blue, onPressed: () => onHome()),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Pal.red, Pal.yellow, Pal.green, Pal.blue, Pal.purple],
          ),
        ],
      ),
    );
  }
}
