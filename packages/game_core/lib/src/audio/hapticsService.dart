import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';
import 'hapticPattern.dart';

/// Fires device haptics for specific gameplay events (GAME_IDEAS.md §3.8-b).
/// Always checks the vibration setting first; tolerates devices with no
/// vibration motor by swallowing platform errors silently.
class HapticsService extends GetxService {
  bool get vibrationEnabled =>
      KeyValueStore.get(HiveService.settingsBox, 'vibration', true);

  Future<void> pulse(HapticPattern pattern) async {
    if (!vibrationEnabled) return;
    try {
      switch (pattern) {
        case HapticPattern.light:
          await HapticFeedback.lightImpact();
        case HapticPattern.medium:
          await HapticFeedback.mediumImpact();
        case HapticPattern.heavy:
          await HapticFeedback.heavyImpact();
        case HapticPattern.selection:
          await HapticFeedback.selectionClick();
        case HapticPattern.doublePulse:
          await HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 80));
          await HapticFeedback.mediumImpact();
      }
    } catch (_) {
      // Device has no vibration motor or platform call failed — ignore.
    }
  }
}
