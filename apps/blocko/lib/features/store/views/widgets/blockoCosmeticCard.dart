import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';

/// One item in the store grid, its frame colored by rarity — the "Neon
/// Drop" equivalent of the shared cutesy `CosmeticCard`.
class BlockoCosmeticCard extends StatelessWidget {
  const BlockoCosmeticCard({super.key, required this.cosmetic});

  final Cosmetic cosmetic;

  @override
  Widget build(BuildContext context) {
    final store = Get.find<StoreController>();
    final inventory = Get.find<InventoryService>();
    final palette = BlockoNeonTokens.of(context);
    return GestureDetector(
      onTap: () => store.onTapCosmetic(cosmetic),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.gapSmall),
        decoration: BoxDecoration(
          color: palette.panelBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cosmetic.rarity.color, width: BorderWidths.thick),
          boxShadow: [BoxShadow(color: cosmetic.rarity.color.withOpacity(0.6), blurRadius: 12, spreadRadius: 1)],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  cosmetic.previewAsset,
                  errorBuilder: (context, error, stack) => Icon(Icons.auto_awesome, size: 40, color: cosmetic.rarity.color),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapExtraSmall),
            Text(cosmetic.nameKey.tr, style: BlockoNeonText.menuItem(color: palette.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.gapExtraSmall),
            Obx(() {
              final owned = inventory.isOwned(cosmetic.id);
              final selected = inventory.selectedId(cosmetic.slot) == cosmetic.id;
              if (selected) return Text('goEquipped'.tr, style: BlockoNeonText.body(color: palette.scoreColor));
              if (owned) return Text('goEquip'.tr, style: BlockoNeonText.body(color: palette.textSecondary));
              if (cosmetic.unlockableByAd) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.smart_display_rounded, size: 12, color: palette.textSecondary),
                    const SizedBox(width: 2),
                    Text('goFree'.tr, style: BlockoNeonText.body(color: palette.textSecondary)),
                  ],
                );
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/gem.svg', package: 'game_core', width: 12, height: 12),
                  const SizedBox(width: 2),
                  Text('${cosmetic.priceGems}', style: BlockoNeonText.body(color: palette.textSecondary)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
