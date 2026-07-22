import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../ads/adService.dart';
import '../ads/consentController.dart';
import '../analytics/analyticsService.dart';
import '../audio/audioService.dart';
import '../audio/hapticsService.dart';
import '../economy/dailyReward/dailyRewardService.dart';
import '../economy/walletService.dart';
import '../storage/hiveService.dart';
import '../store/inventoryService.dart';
import '../store/storeController.dart';
import '../ui/settings/settingsController.dart';
import 'gameConfig.dart';

/// Shared app bootstrap every game's `main.dart` calls before `runApp`
/// (GAME_IDEAS.md §3.2).
Future<void> bootstrapGame({required GameConfig config}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  Get.put(AnalyticsService()..init());
  Get.put(ConsentController());
  await Get.putAsync(() => AudioService().init());
  Get.put(HapticsService());
  Get.put(SettingsController());

  await Get.putAsync(() => WalletService().init());
  await Get.putAsync(() => InventoryService(config.storeCatalog).init());
  Get.put(StoreController(config.economy));

  final dailyRewardConfig = config.economy.dailyReward;
  if (dailyRewardConfig != null) {
    await Get.putAsync(() => DailyRewardService(dailyRewardConfig).init());
  }

  await Get.putAsync(() => AdService(config.adUnits, config.adPolicy).init());
}
