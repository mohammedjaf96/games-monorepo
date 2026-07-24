import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../audio/audioService.dart';
import '../../audio/hapticPattern.dart';
import '../../audio/hapticsService.dart';
import '../../storage/hiveService.dart';
import '../../storage/keyValueStore.dart';

/// Shared Sound/Vibration/Music/Language settings (GAME_IDEAS.md §3.16).
/// Every toggle applies immediately and persists to Hive right away.
class SettingsController extends GetxController {
  SettingsController({this.privacyPolicyUrl});

  final String? privacyPolicyUrl;

  final RxBool sound = true.obs;
  final RxBool vibration = true.obs;
  final RxBool music = true.obs;
  final RxString locale = 'en'.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  @override
  void onInit() {
    super.onInit();
    sound.value = KeyValueStore.get(HiveService.settingsBox, 'sound', true);
    vibration.value = KeyValueStore.get(HiveService.settingsBox, 'vibration', true);
    music.value = KeyValueStore.get(HiveService.settingsBox, 'music', true);
    locale.value = KeyValueStore.get(HiveService.settingsBox, 'lang', deviceLocaleOrEnglish());
    themeMode.value = themeModeFromKey(KeyValueStore.get(HiveService.settingsBox, 'themeMode', 'system'));
  }

  ThemeMode themeModeFromKey(String key) {
    switch (key) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String keyForThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await save('themeMode', keyForThemeMode(mode));
    Get.changeThemeMode(mode);
  }

  String deviceLocaleOrEnglish() {
    final deviceLanguage = Get.deviceLocale?.languageCode;
    return deviceLanguage == 'ar' ? 'ar' : 'en';
  }

  Future<void> toggleSound() async {
    sound.value = !sound.value;
    await save('sound', sound.value);
    if (!sound.value) await audio.stopAllSfx();
  }

  Future<void> toggleVibration() async {
    vibration.value = !vibration.value;
    await save('vibration', vibration.value);
    if (vibration.value) await haptics.pulse(HapticPattern.light);
  }

  Future<void> toggleMusic() async {
    music.value = !music.value;
    await save('music', music.value);
    if (music.value) {
      await audio.resumeBgmIfKnown();
    } else {
      await audio.stopBgm();
    }
  }

  Future<void> setLocale(String languageCode) async {
    locale.value = languageCode;
    await save('lang', languageCode);
    Get.updateLocale(Locale(languageCode));
  }

  Future<void> save(String key, dynamic value) => KeyValueStore.set(HiveService.settingsBox, key, value);

  Future<void> openPrivacyPolicy() async {
    final url = privacyPolicyUrl;
    if (url == null) return;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      // No browser available / URL failed to launch — never crash the app over this.
    }
  }
}
