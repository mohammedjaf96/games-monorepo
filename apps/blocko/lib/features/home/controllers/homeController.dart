import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/routing/appRoutes.dart';

/// Drives the Home screen: best score display and navigation
/// (GAME_IDEAS.md §4.3).
class HomeController extends GetxController {
  final RxInt best = 0.obs;
  final WalletService wallet = Get.find<WalletService>();

  @override
  void onInit() {
    super.onInit();
    best.value = KeyValueStore.get(HiveService.progressBox, 'bestScore_blocko', 0);
  }

  void playTapped() => Get.toNamed(AppRoutes.game);

  void shopTapped() => Get.toNamed(AppRoutes.store);

  void settingsTapped() => Get.toNamed(AppRoutes.settings);
}
