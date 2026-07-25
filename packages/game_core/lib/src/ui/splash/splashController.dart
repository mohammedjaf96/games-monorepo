import 'package:get/get.dart';

import '../../ads/adService.dart';
import '../../audio/audioService.dart';
import '../../economy/dailyReward/dailyRewardService.dart';
import 'splashConfig.dart';

/// Drives the splash screen: a short brand delay, then App-Open ad, then the
/// daily reward dialog if this is a new day, then Home (GAME_IDEAS.md §3.13.1).
class SplashController extends GetxController {
  SplashController(this.config);

  final SplashConfig config;
  final AdService ads = Get.find<AdService>();
  final AudioService audio = Get.find<AudioService>();

  @override
  void onInit() {
    super.onInit();
    startBgm();
    navigateWhenReady();
  }

  void startBgm() {
    final bgmAssetPath = config.bgmAssetPath;
    if (bgmAssetPath != null) audio.playBgm(bgmAssetPath);
  }

  Future<void> navigateWhenReady() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    await ads.showAppOpenIfAvailable();
    Get.offAllNamed(config.homeRoute);

    if (Get.isRegistered<DailyRewardService>()) {
      final dailyReward = Get.find<DailyRewardService>();
      if (dailyReward.canClaimToday) {
        await Future.delayed(const Duration(milliseconds: 400));
        Get.dialog(config.dailyRewardDialogBuilder(), barrierDismissible: false);
      }
    }
  }
}
