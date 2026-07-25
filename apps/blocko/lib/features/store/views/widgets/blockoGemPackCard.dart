import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoDialogButton.dart';

/// A gem pack in the store's Gems tab — the "Neon Drop" equivalent of the
/// shared cutesy `GemPackCard`.
class BlockoGemPackCard extends StatelessWidget {
  const BlockoGemPackCard({super.key, required this.pack});

  final GemPack pack;

  @override
  Widget build(BuildContext context) {
    final store = Get.find<StoreController>();
    final palette = BlockoNeonTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: palette.panelBackground,
        border: Border.all(color: palette.panelBorder),
        boxShadow: [BoxShadow(color: palette.boardOuterGlow, blurRadius: 16)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/gem.svg', package: 'game_core', width: 40, height: 40),
          const SizedBox(height: AppSizes.gapExtraSmall),
          Text('+${pack.amount}', style: BlockoNeonText.overlayTitle(color: palette.textPrimary, size: 20)),
          if (pack.badge != null) ...[
            const SizedBox(height: AppSizes.gapExtraSmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapSmall, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: palette.scoreColor,
              ),
              child: Text(pack.badge!, style: BlockoNeonText.body(color: const Color(0xFF0A0713)).copyWith(fontSize: 11)),
            ),
          ],
          const SizedBox(height: AppSizes.gapSmall),
          BlockoDialogButton(label: 'goWatchAd'.tr, color: palette.scoreColor, filled: false, onTap: () => store.claimGemPack(pack)),
        ],
      ),
    );
  }
}
