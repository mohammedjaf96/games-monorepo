import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/appSizes.dart';
import '../theme/appText.dart';
import '../theme/borderWidths.dart';
import '../theme/outlineColor.dart';
import '../theme/pal.dart';
import '../theme/stickerDecoration.dart';

/// The top-bar gem pill: icon + rolling counter + a round "+" button
/// (GAME_IDEAS.md §3.14.4).
class CurrencyPill extends StatelessWidget {
  const CurrencyPill({
    super.key,
    required this.amount,
    this.onTapPlus,
    this.trackColor = const Color(0xFF2A1856),
  });

  final int amount;
  final VoidCallback? onTapPlus;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.currencyPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapSmall),
      decoration: stickerDecoration(
        fill: trackColor,
        radius: AppSizes.currencyPillHeight / 2,
        border: BorderWidths.thin,
        drop: 3,
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
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: amount, end: amount),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) {
              return Text('$value', style: AppText.label(color: Colors.white));
            },
          ),
          if (onTapPlus != null) ...[
            const SizedBox(width: AppSizes.gapSmall),
            GestureDetector(
              onTap: onTapPlus,
              child: Container(
                width: AppSizes.currencyPlusButtonSize,
                height: AppSizes.currencyPlusButtonSize,
                alignment: Alignment.center,
                decoration: stickerDecoration(
                  fill: Pal.green,
                  radius: AppSizes.currencyPlusButtonSize / 2,
                  border: BorderWidths.thin,
                  drop: 2,
                ),
                child: const Icon(Icons.add, size: 14, color: OutlineColor.color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
