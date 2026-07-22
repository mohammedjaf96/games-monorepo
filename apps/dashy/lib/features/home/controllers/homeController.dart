import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/routing/appRoutes.dart';

/// Drives the Home screen: best distance display and navigation
/// (GAME_IDEAS.md §5.3).
class HomeController extends GetxController {
  final RxInt best = 0.obs;
  final RxBool shieldPending = false.obs;
  final WalletService wallet = Get.find<WalletService>();
  final AdService ads = Get.find<AdService>();

  @override
  void onInit() {
    super.onInit();
    best.value = KeyValueStore.get(HiveService.progressBox, 'bestScore_dashy', 0);
    shieldPending.value = KeyValueStore.get(HiveService.adMetaBox, 'dashyShieldPending', false);
  }

  void playTapped() => Get.toNamed(AppRoutes.game);

  void shopTapped() => Get.toNamed(AppRoutes.store);

  void settingsTapped() => Get.toNamed(AppRoutes.settings);

  /// Watch a rewarded ad to start the next run with a collision-absorbing
  /// shield (GAME_IDEAS.md §5.7).
  Future<void> activateShield() async {
    if (shieldPending.value) return;
    final earned = await ads.showRewarded('revive_shield');
    if (earned) {
      await KeyValueStore.set(HiveService.adMetaBox, 'dashyShieldPending', true);
      shieldPending.value = true;
    }
  }
}
