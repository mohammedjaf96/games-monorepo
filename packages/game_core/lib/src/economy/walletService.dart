import 'package:get/get.dart';

import '../analytics/analyticsService.dart';
import '../audio/audioService.dart';
import '../audio/hapticPattern.dart';
import '../audio/hapticsService.dart';
import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';

/// The single source of truth for the gem balance (GAME_IDEAS.md §3.11.3).
/// Every earn/spend persists immediately and fires audio/haptic/analytics.
class WalletService extends GetxService {
  final RxInt balance = 0.obs;

  final AnalyticsService analytics = Get.find<AnalyticsService>();
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  int get amount => balance.value;

  Future<WalletService> init() async {
    balance.value = KeyValueStore.get(HiveService.economyBox, 'balance', 0);
    return this;
  }

  Future<void> earn(int value, {required String source}) async {
    if (value <= 0) return;
    balance.value += value;
    await KeyValueStore.set(HiveService.economyBox, 'balance', balance.value);
    await audio.playSfx('coin');
    await haptics.pulse(HapticPattern.selection);
    analytics.log('gems_earned', {'source': source, 'amount': value});
  }

  Future<bool> trySpend(int value, {required String reason}) async {
    if (value <= 0) return true;
    if (balance.value < value) {
      analytics.log('insufficient_gems', {'item': reason});
      return false;
    }
    balance.value -= value;
    await KeyValueStore.set(HiveService.economyBox, 'balance', balance.value);
    analytics.log('gems_spent', {'item': reason, 'amount': value});
    return true;
  }
}
