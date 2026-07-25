import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoDialogButton.dart';

/// Blocko's own "Neon Drop"-styled first-launch tutorial card — the same
/// constructor shape as the shared cutesy `HowToPlayDialog`, swapped in at
/// `GameController.maybeShowTutorial`'s call site.
class BlockoHowToPlayDialog extends StatelessWidget {
  const BlockoHowToPlayDialog({super.key, required this.game, required this.goal, required this.controls, required this.onGotIt});

  final String game;
  final String goal;
  final String controls;
  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.all(24),
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
                'labelHowToPlay'.tr.toUpperCase(),
                style: BlockoNeonText.overlayTitle(color: palette.textPrimary, size: 20).copyWith(
                  shadows: [Shadow(color: palette.scoreGlow, blurRadius: 14)],
                ),
              ),
              const SizedBox(height: 14),
              Text(goal, style: BlockoNeonText.body(color: palette.textPrimary), textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(controls, style: BlockoNeonText.body(color: palette.scoreColor), textAlign: TextAlign.center),
              const SizedBox(height: 22),
              BlockoDialogButton(label: 'menuGotIt'.tr, color: palette.scoreColor, filled: true, onTap: onGotIt),
            ],
          ),
        ),
      ),
    );
  }
}
