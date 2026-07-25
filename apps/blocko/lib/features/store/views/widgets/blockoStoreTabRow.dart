import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';

/// The Store screen's Gems + cosmetic-category tab strip — the "Neon Drop"
/// equivalent of the shared cutesy tab row inside `StorePage`.
class BlockoStoreTabRow extends StatelessWidget {
  const BlockoStoreTabRow({super.key, required this.catalog, required this.selectedIndex, required this.onSelect});

  final StoreCatalog catalog;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: catalog.categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: AppSizes.gapSmall),
        itemBuilder: (context, index) {
          final isGemsTab = index == 0;
          final label = isGemsTab ? 'tabGems'.tr : catalog.categories[index - 1].nameKey.tr;
          final active = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusChip),
                color: active ? palette.scoreColor : Colors.transparent,
                border: Border.all(color: active ? palette.scoreColor : palette.panelBorder),
              ),
              child: Text(
                label,
                style: BlockoNeonText.menuItem(color: active ? const Color(0xFF0A0713) : palette.textSecondary),
              ),
            ),
          );
        },
      ),
    );
  }
}
