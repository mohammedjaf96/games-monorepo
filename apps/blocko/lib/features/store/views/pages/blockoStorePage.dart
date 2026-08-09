import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoWalletBar.dart';
import '../widgets/blockoCosmeticCard.dart';
import '../widgets/blockoGemPackCard.dart';
import '../widgets/blockoStoreTabRow.dart';

/// Blocko's own "Neon Drop"-styled Store screen — reuses the shared
/// `StoreController` (purchase/unlock logic is identical across every
/// game) but replaces the cutesy sticker tabs/cards with neon panels.
class BlockoStorePage extends GetView<StoreController> {
  const BlockoStorePage({super.key, required this.catalog});

  final StoreCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: palette.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.screenMargin),
            child: Column(
              children: [
                BlockoWalletBar(onBack: Get.back, onTapPlus: () => controller.selectedCategoryIndex.value = 0),
                const SizedBox(height: AppSizes.gapLarge),
                Text(
                  'labelStore'.tr.toUpperCase(),
                  style: BlockoNeonText.overlayTitle(color: palette.scoreColor, size: 22).copyWith(
                    shadows: [Shadow(color: palette.scoreGlow, blurRadius: 14)],
                  ),
                ),
                const SizedBox(height: AppSizes.gapMedium),
                Obx(
                  () => BlockoStoreTabRow(
                    catalog: catalog,
                    selectedIndex: controller.selectedCategoryIndex.value,
                    onSelect: (index) => controller.selectedCategoryIndex.value = index,
                  ),
                ),
                const SizedBox(height: AppSizes.gapLarge),
                Expanded(
                  child: Obx(() {
                    if (controller.selectedCategoryIndex.value == 0) {
                      return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSizes.gapMedium,
                        crossAxisSpacing: AppSizes.gapMedium,
                        children: controller.economyConfig.gemPacks.map((pack) => BlockoGemPackCard(pack: pack)).toList(),
                      );
                    }
                    final category = catalog.categories[controller.selectedCategoryIndex.value - 1];
                    final items = catalog.cosmetics.where((cosmetic) => cosmetic.slot == category.slot).toList();
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSizes.gapMedium,
                        crossAxisSpacing: AppSizes.gapMedium,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) => BlockoCosmeticCard(cosmetic: items[index]),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
