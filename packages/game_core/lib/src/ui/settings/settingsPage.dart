import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';
import '../outlinedText.dart';
import '../stickerIconButton.dart';
import 'settingsController.dart';
import 'settingsToggleRow.dart';

/// The shared settings screen — locked, mandatory in every game (GAME_IDEAS.md §3.16).
class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenMargin),
          child: Column(
            children: [
              Row(
                children: [
                  const OutlinedText('SETTINGS', size: 22, fill: Colors.white),
                  const Spacer(),
                  StickerIconButton(
                    iconAsset: 'assets/icons/close.svg',
                    fill: Pal.red,
                    onPressed: Get.back,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.gapLarge),
              Obx(
                () => SettingsToggleRow(
                  iconAsset: 'assets/icons/sound.svg',
                  label: 'labelSound'.tr,
                  value: controller.sound.value,
                  onChanged: (_) => controller.toggleSound(),
                ),
              ),
              Obx(
                () => SettingsToggleRow(
                  iconAsset: 'assets/icons/vibration.svg',
                  label: 'labelVibration'.tr,
                  value: controller.vibration.value,
                  onChanged: (_) => controller.toggleVibration(),
                ),
              ),
              Obx(
                () => SettingsToggleRow(
                  iconAsset: 'assets/icons/music.svg',
                  label: 'labelMusic'.tr,
                  value: controller.music.value,
                  onChanged: (_) => controller.toggleMusic(),
                ),
              ),
              const SizedBox(height: AppSizes.gapSmall),
              Container(
                padding: const EdgeInsets.all(AppSizes.gapMedium),
                decoration: stickerDecoration(
                  fill: Colors.white,
                  radius: AppSizes.radiusCard,
                  border: BorderWidths.thin,
                  drop: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/language.svg', package: 'game_core', width: 18, height: 18),
                          const SizedBox(width: AppSizes.gapSmall),
                          Text('labelLanguage'.tr, style: AppText.body()),
                        ],
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.setLocale('en'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium, vertical: AppSizes.gapExtraSmall),
                          margin: const EdgeInsets.only(right: AppSizes.gapSmall),
                          decoration: stickerDecoration(
                            fill: controller.locale.value == 'en' ? Pal.blue : Colors.white,
                            radius: AppSizes.radiusChip,
                            border: BorderWidths.thin,
                            drop: 2,
                          ),
                          child: Text('EN', style: AppText.label(color: controller.locale.value == 'en' ? Colors.white : Pal.blue)),
                        ),
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.setLocale('ar'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.gapMedium, vertical: AppSizes.gapExtraSmall),
                          decoration: stickerDecoration(
                            fill: controller.locale.value == 'ar' ? Pal.blue : Colors.white,
                            radius: AppSizes.radiusChip,
                            border: BorderWidths.thin,
                            drop: 2,
                          ),
                          child: Text('ع', style: AppText.label(color: controller.locale.value == 'ar' ? Colors.white : Pal.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: controller.openPrivacyPolicy,
                child: Text(
                  'labelPrivacyPolicy'.tr,
                  style: AppText.caption(color: Pal.blue),
                ),
              ),
              const SizedBox(height: AppSizes.gapExtraSmall),
              Text('${'labelVersion'.tr}: 1.0.0', style: AppText.caption()),
            ],
          ),
        ),
      ),
    );
  }
}
