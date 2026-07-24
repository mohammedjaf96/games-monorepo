import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';
import '../../theme/surfaceTone.dart';
import 'settingsController.dart';

/// The System/Light/Dark theme picker row on the Settings screen
/// (GAME_IDEAS.md §3.16).
class ThemeModeRow extends StatelessWidget {
  const ThemeModeRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapMedium),
      decoration: stickerDecoration(fill: surfaceTone(Colors.white), radius: AppSizes.radiusCard, border: BorderWidths.thin, drop: 4),
      child: Row(
        children: [
          Expanded(child: Text('labelTheme'.tr, style: AppText.body())),
          Obx(
            () => GestureDetector(
              onTap: () => controller.setThemeMode(ThemeMode.system),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium, vertical: AppSizes.gapExtraSmall),
                margin: const EdgeInsets.only(right: AppSizes.gapSmall),
                decoration: stickerDecoration(
                  fill: controller.themeMode.value == ThemeMode.system ? Pal.blue : surfaceTone(Colors.white),
                  radius: AppSizes.radiusChip,
                  border: BorderWidths.thin,
                  drop: 2,
                ),
                child: Text(
                  'themeSystem'.tr,
                  style: AppText.label(color: controller.themeMode.value == ThemeMode.system ? Colors.white : Pal.blue),
                ),
              ),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () => controller.setThemeMode(ThemeMode.light),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium, vertical: AppSizes.gapExtraSmall),
                margin: const EdgeInsets.only(right: AppSizes.gapSmall),
                decoration: stickerDecoration(
                  fill: controller.themeMode.value == ThemeMode.light ? Pal.blue : surfaceTone(Colors.white),
                  radius: AppSizes.radiusChip,
                  border: BorderWidths.thin,
                  drop: 2,
                ),
                child: Text(
                  'themeLight'.tr,
                  style: AppText.label(color: controller.themeMode.value == ThemeMode.light ? Colors.white : Pal.blue),
                ),
              ),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () => controller.setThemeMode(ThemeMode.dark),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium, vertical: AppSizes.gapExtraSmall),
                decoration: stickerDecoration(
                  fill: controller.themeMode.value == ThemeMode.dark ? Pal.blue : surfaceTone(Colors.white),
                  radius: AppSizes.radiusChip,
                  border: BorderWidths.thin,
                  drop: 2,
                ),
                child: Text(
                  'themeDark'.tr,
                  style: AppText.label(color: controller.themeMode.value == ThemeMode.dark ? Colors.white : Pal.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
