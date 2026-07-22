import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../store/cosmetic.dart';
import '../../store/inventoryService.dart';
import '../../store/storeController.dart';
import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/outlineColor.dart';
import '../../theme/pal.dart';

/// One item in the store grid, its frame colored by rarity (GAME_IDEAS.md §3.11.7-c).
class CosmeticCard extends StatelessWidget {
  const CosmeticCard({super.key, required this.cosmetic});

  final Cosmetic cosmetic;

  @override
  Widget build(BuildContext context) {
    final store = Get.find<StoreController>();
    final inventory = Get.find<InventoryService>();
    return GestureDetector(
      onTap: () => store.onTapCosmetic(cosmetic),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.gapSmall),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border: Border.all(color: cosmetic.rarity.color, width: BorderWidths.thick),
          boxShadow: [BoxShadow(color: cosmetic.rarity.color, offset: const Offset(0, 5), blurRadius: 0)],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  cosmetic.previewAsset,
                  errorBuilder: (context, error, stack) =>
                      Icon(Icons.auto_awesome, size: 40, color: cosmetic.rarity.color),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapExtraSmall),
            Text(cosmetic.nameKey.tr, style: AppText.label(), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.gapExtraSmall),
            Obx(() {
              final owned = inventory.isOwned(cosmetic.id);
              final selected = inventory.selectedId(cosmetic.slot) == cosmetic.id;
              if (selected) return Text('goEquipped'.tr, style: AppText.caption(color: Pal.green));
              if (owned) return Text('goEquip'.tr, style: AppText.caption(color: Pal.blue));
              if (cosmetic.unlockableByAd) return Text('🎬 ${'goFree'.tr}', style: AppText.caption());
              return Text('💜 ${cosmetic.priceGems}', style: AppText.caption(color: OutlineColor.color));
            }),
          ],
        ),
      ),
    );
  }
}
