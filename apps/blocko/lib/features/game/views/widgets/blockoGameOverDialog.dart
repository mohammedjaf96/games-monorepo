import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoDialogButton.dart';

/// Blocko's own "Neon Drop"-styled Game Over popup — swapped in for the
/// shared cutesy `GameOverDialog` via `GameSessionFlow.showGameOver`'s
/// `dialogBuilder`, so the whole round-end moment matches the rest of the
/// game's look instead of the other games' sticker theme.
class BlockoGameOverDialog extends StatelessWidget {
  const BlockoGameOverDialog({
    super.key,
    required this.game,
    required this.score,
    required this.best,
    required this.isNewRecord,
    required this.onRevive,
    required this.onDoubleCoins,
    required this.onRetry,
    required this.onHome,
  });

  final String game;
  final int score;
  final int best;
  final bool isNewRecord;
  final Future<void> Function()? onRevive;
  final Future<void> Function() onDoubleCoins;
  final Future<void> Function() onRetry;
  final Future<void> Function() onHome;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: palette.panelBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.panelBorder),
            boxShadow: [BoxShadow(color: palette.boardOuterGlow, blurRadius: 30, spreadRadius: 2)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (isNewRecord ? 'labelNewRecord' : 'labelGameOver').tr.toUpperCase(),
                textAlign: TextAlign.center,
                style: BlockoNeonText.overlayTitle(color: palette.textPrimary, size: 22).copyWith(
                  shadows: [Shadow(color: palette.scoreGlow, blurRadius: 16)],
                ),
              ),
              if (!isNewRecord) ...[
                const SizedBox(height: 6),
                Text('labelBetterLuck'.tr, textAlign: TextAlign.center, style: BlockoNeonText.body(color: palette.textSecondary)),
              ],
              const SizedBox(height: 20),
              Text(
                '$score',
                style: BlockoNeonText.overlayTitle(color: palette.scoreColor, size: 40).copyWith(
                  shadows: [Shadow(color: palette.scoreGlow, blurRadius: 18)],
                ),
              ),
              const SizedBox(height: 4),
              Text('${'labelBest'.tr}: $best', style: BlockoNeonText.body(color: palette.textSecondary)),
              const SizedBox(height: 24),
              if (onRevive != null) ...[
                BlockoDialogButton(label: 'goRevive'.tr, color: palette.scoreColor, filled: true, onTap: () => onRevive!()),
                const SizedBox(height: 10),
              ],
              BlockoDialogButton(label: 'goDoubleCoins'.tr, color: palette.titleGlow, filled: false, onTap: () => onDoubleCoins()),
              const SizedBox(height: 10),
              BlockoDialogButton(
                label: 'menuRetry'.tr,
                color: onRevive != null ? palette.titleGlow : palette.scoreColor,
                filled: onRevive == null,
                onTap: () => onRetry(),
              ),
              const SizedBox(height: 10),
              BlockoDialogButton(label: 'menuHome'.tr, color: palette.textSecondary, filled: false, onTap: () => onHome()),
            ],
          ),
        ),
      ),
    );
  }
}
