import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../store/storeCatalog.dart';
import '../../store/storeController.dart';
import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/stickerDecoration.dart';
import 'cosmeticCard.dart';
import 'gemPackCard.dart';
import 'walletBar.dart';

/// The shared store screen: a Gems tab plus one tab per cosmetic category
/// (GAME_IDEAS.md §3.11.7-b). Tab/card colors use the game's own primary
/// color; gems stay purple/pink everywhere.
class StorePage extends GetView<StoreController> {
  const StorePage({super.key, required this.catalog, required this.primaryColor});

  final StoreCatalog catalog;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenMargin),
          child: Column(
            children: [
              WalletBar(onBack: Get.back, onTapPlus: () => controller.selectedCategoryIndex.value = 0),
              const SizedBox(height: AppSizes.gapLarge),
              Text('labelStore'.tr, style: AppText.title()),
              const SizedBox(height: AppSizes.gapMedium),
              SizedBox(
                height: 40,
                child: Obx(
                  () => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: catalog.categories.length + 1,
                    separatorBuilder: (context, index) => const SizedBox(width: AppSizes.gapSmall),
                    itemBuilder: (context, index) {
                      final isGemsTab = index == 0;
                      final label = isGemsTab ? 'tabGems'.tr : catalog.categories[index - 1].nameKey.tr;
                      final active = controller.selectedCategoryIndex.value == index;
                      return GestureDetector(
                        onTap: () => controller.selectedCategoryIndex.value = index,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium),
                          alignment: Alignment.center,
                          decoration: stickerDecoration(
                            fill: active ? primaryColor : Colors.white,
                            radius: AppSizes.radiusChip,
                            border: BorderWidths.thin,
                            drop: 2,
                          ),
                          child: Text(
                            label,
                            style: AppText.label(color: active ? Colors.white : primaryColor),
                          ),
                        ),
                      );
                    },
                  ),
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
                      children: controller.economyConfig.gemPacks
                          .map((pack) => GemPackCard(pack: pack))
                          .toList(),
                    );
                  }
                  final category = catalog.categories[controller.selectedCategoryIndex.value - 1];
                  final items = catalog.cosmetics.where((c) => c.slot == category.slot).toList();
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSizes.gapMedium,
                      crossAxisSpacing: AppSizes.gapMedium,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) => CosmeticCard(cosmetic: items[index]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
