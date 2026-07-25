import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_core/game_core.dart';

import '../theme/blockoNeonText.dart';
import '../theme/blockoNeonTokens.dart';

/// The top-bar gem pill — the "Neon Drop" equivalent of the shared cutesy
/// `CurrencyPill`.
class BlockoCurrencyPill extends StatelessWidget {
  const BlockoCurrencyPill({super.key, required this.amount, this.onTapPlus});

  final int amount;
  final VoidCallback? onTapPlus;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Container(
      height: AppSizes.currencyPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.currencyPillHeight / 2),
        color: palette.panelBackground,
        border: Border.all(color: palette.panelBorder),
        boxShadow: [BoxShadow(color: palette.hamburgerGlow, blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/gem.svg',
            package: 'game_core',
            width: AppSizes.currencyGemIconSize,
            height: AppSizes.currencyGemIconSize,
          ),
          const SizedBox(width: AppSizes.gapExtraSmall),
          AnimatedCounter(value: amount, style: BlockoNeonText.score(color: palette.textPrimary)),
          if (onTapPlus != null) ...[
            const SizedBox(width: AppSizes.gapSmall),
            GestureDetector(
              onTap: onTapPlus,
              child: Container(
                width: AppSizes.currencyPlusButtonSize,
                height: AppSizes.currencyPlusButtonSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: palette.scoreColor),
                child: const Icon(Icons.add, size: 14, color: Color(0xFF0A0713)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
