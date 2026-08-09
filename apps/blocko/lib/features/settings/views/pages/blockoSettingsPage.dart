import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import '../../../../core/widgets/blockoNeonIconButton.dart';
import '../widgets/blockoSegmentedRow.dart';
import '../widgets/blockoSettingsToggleRow.dart';

/// Blocko's own "Neon Drop"-styled Settings screen — reuses the shared
/// `SettingsController` (state/persistence is identical across every game)
/// but replaces the cutesy sticker view with neon panels.
class BlockoSettingsPage extends GetView<SettingsController> {
  const BlockoSettingsPage({super.key});

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
                Row(
                  children: [
                    Text(
                      'labelSettings'.tr.toUpperCase(),
                      style: BlockoNeonText.overlayTitle(color: palette.scoreColor, size: 22),
                    ),
                    const Spacer(),
                    BlockoNeonIconButton(iconAsset: 'assets/icons/close.svg', onPressed: Get.back),
                  ],
                ),
                const SizedBox(height: AppSizes.gapLarge),
                Obx(
                  () => BlockoSettingsToggleRow(
                    iconAsset: 'assets/icons/sound.svg',
                    label: 'labelSound'.tr,
                    value: controller.sound.value,
                    onChanged: (_) => controller.toggleSound(),
                  ),
                ),
                Obx(
                  () => BlockoSettingsToggleRow(
                    iconAsset: 'assets/icons/vibration.svg',
                    label: 'labelVibration'.tr,
                    value: controller.vibration.value,
                    onChanged: (_) => controller.toggleVibration(),
                  ),
                ),
                Obx(
                  () => BlockoSettingsToggleRow(
                    iconAsset: 'assets/icons/music.svg',
                    label: 'labelMusic'.tr,
                    value: controller.music.value,
                    onChanged: (_) => controller.toggleMusic(),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => BlockoSegmentedRow(
                    label: 'labelLanguage'.tr,
                    options: const ['EN', 'ع'],
                    selectedIndex: controller.locale.value == 'en' ? 0 : 1,
                    onSelect: (index) => controller.setLocale(index == 0 ? 'en' : 'ar'),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => BlockoSegmentedRow(
                    label: 'labelTheme'.tr,
                    options: ['themeSystem'.tr, 'themeLight'.tr, 'themeDark'.tr],
                    selectedIndex: controller.themeMode.value == ThemeMode.light
                        ? 1
                        : controller.themeMode.value == ThemeMode.dark
                            ? 2
                            : 0,
                    onSelect: (index) => controller.setThemeMode(
                      index == 1 ? ThemeMode.light : (index == 2 ? ThemeMode.dark : ThemeMode.system),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: controller.openPrivacyPolicy,
                  child: Text('labelPrivacyPolicy'.tr, style: BlockoNeonText.body(color: palette.scoreColor)),
                ),
                const SizedBox(height: 4),
                Text('${'labelVersion'.tr}: 1.0.0', style: BlockoNeonText.body(color: palette.textSecondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
