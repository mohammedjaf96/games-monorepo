import 'package:get/get.dart';

import '../ads/adService.dart';
import '../analytics/analyticsService.dart';
import '../economy/economyConfig.dart';
import '../economy/gemPack.dart';
import '../economy/walletService.dart';
import '../ui/store/earnGemsSheet.dart';
import 'cosmetic.dart';
import 'inventoryService.dart';

/// Generic purchase/unlock/claim coordinator shared by every game's store
/// screen (GAME_IDEAS.md §3.11.6).
class StoreController extends GetxController {
  StoreController(this.economyConfig);

  final EconomyConfig economyConfig;
  final WalletService wallet = Get.find<WalletService>();
  final InventoryService inventory = Get.find<InventoryService>();
  final AdService ads = Get.find<AdService>();
  final AnalyticsService analytics = Get.find<AnalyticsService>();

  /// Which store tab (index into `StoreCatalog.categories`, offset by the
  /// Gems tab at index 0) is currently shown.
  final RxInt selectedCategoryIndex = 0.obs;

  /// Set whenever a purchase is blocked by an insufficient balance — opens
  /// the Earn Gems sheet automatically.
  final Rx<Cosmetic?> insufficientFundsTarget = Rx<Cosmetic?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(insufficientFundsTarget, (Cosmetic? target) {
      if (target != null) {
        Get.bottomSheet(EarnGemsSheet(target: target)).then((_) => insufficientFundsTarget.value = null);
      }
    });
  }

  Future<void> onTapCosmetic(Cosmetic cosmetic) async {
    if (inventory.isOwned(cosmetic.id)) {
      await inventory.select(cosmetic.slot, cosmetic.id);
      return;
    }
    if (cosmetic.unlockableByAd) {
      final earned = await ads.showRewarded(placement: 'unlock_cosmetic');
      if (earned) {
        await inventory.unlock(cosmetic.id);
        await inventory.select(cosmetic.slot, cosmetic.id);
      }
      return;
    }
    if (wallet.amount >= cosmetic.priceGems) {
      final spent = await wallet.trySpend(cosmetic.priceGems, reason: 'cosmetic:${cosmetic.id}');
      if (spent) {
        await inventory.unlock(cosmetic.id);
        await inventory.select(cosmetic.slot, cosmetic.id);
      }
    } else {
      analytics.log('insufficient_gems', {'item': cosmetic.id});
      analytics.log('earn_sheet_shown', {'target': cosmetic.id});
      insufficientFundsTarget.value = cosmetic;
    }
  }

  Future<bool> claimGemPack(GemPack pack) async {
    if (!economyConfig.caps.canClaim(pack)) return false;
    final earned = await ads.showRewarded(placement: 'shop_gem_pack');
    if (earned) {
      await wallet.earn(pack.amount, source: 'gem_pack:${pack.id}');
      await economyConfig.caps.markClaimed(pack);
      analytics.log('gem_pack_claimed', {'pack': pack.id, 'via_ad': true});
    }
    return earned;
  }
}
