import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../analytics/analyticsService.dart';
import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';
import 'adPolicy.dart';
import 'adUnitPair.dart';
import 'adUnits.dart';
import 'consentController.dart';

String platformAdUnitId(AdUnitPair pair) => GetPlatform.isIOS ? pair.ios : pair.android;

/// The revenue core: preloads and shows App-Open/Interstitial/Rewarded ads
/// and exposes a menu-only banner widget (GAME_IDEAS.md §3.5/§3.6).
class AdService extends GetxService {
  AdService(this.units, this.policy);

  final AdUnits units;
  final AdPolicy policy;

  final ConsentController consent = Get.find<ConsentController>();
  final AnalyticsService analytics = Get.find<AnalyticsService>();

  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;
  AppOpenAd? appOpenAd;
  final Map<String, BannerAd> bannerAds = {};
  final DateTime sessionStartTime = DateTime.now();

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    await consent.ensure();
    preloadInterstitial();
    preloadRewarded();
    preloadAppOpen();
    return this;
  }

  void preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: platformAdUnitId(units.interstitial),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => interstitialAd = ad,
        onAdFailedToLoad: (error) => interstitialAd = null,
      ),
    );
  }

  void preloadRewarded() {
    RewardedAd.load(
      adUnitId: platformAdUnitId(units.rewarded),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => rewardedAd = ad,
        onAdFailedToLoad: (error) => rewardedAd = null,
      ),
    );
  }

  void preloadAppOpen() {
    AppOpenAd.load(
      adUnitId: platformAdUnitId(units.appOpen),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => appOpenAd = ad,
        onAdFailedToLoad: (error) => appOpenAd = null,
      ),
    );
  }

  /// Shows the preloaded interstitial only if every frequency-capping rule
  /// in §3.6 is satisfied. `placement` is the analytics context (e.g. `game_over`).
  Future<void> maybeShowInterstitial({required String placement}) async {
    final now = DateTime.now();
    if (now.difference(sessionStartTime).inSeconds < policy.firstSessionGraceSeconds) return;

    final lastInterstitialAt = KeyValueStore.get(HiveService.adMetaBox, 'lastInterstitialAt', 0);
    final secondsSinceInterstitial = (now.millisecondsSinceEpoch - lastInterstitialAt) / 1000;
    if (secondsSinceInterstitial < policy.minInterstitialGapSeconds) return;

    final lastAppOpenAt = KeyValueStore.get(HiveService.adMetaBox, 'lastAppOpenAt', 0);
    final secondsSinceAppOpen = (now.millisecondsSinceEpoch - lastAppOpenAt) / 1000;
    if (secondsSinceAppOpen < policy.appOpenMinGapSeconds) return;

    final gameOverCounter = KeyValueStore.get(HiveService.adMetaBox, 'gameOverCounter', 0);
    if (policy.interstitialEveryNGameOvers > 0 &&
        gameOverCounter % policy.interstitialEveryNGameOvers != 0) {
      return;
    }

    final ad = interstitialAd;
    if (ad == null) {
      analytics.log('ad_failed', {'type': 'interstitial', 'placement': placement, 'code': 'not_loaded'});
      return;
    }
    interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (dismissed) {
        dismissed.dispose();
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (failed, error) {
        failed.dispose();
        preloadInterstitial();
      },
    );
    await KeyValueStore.set(HiveService.adMetaBox, 'lastInterstitialAt', now.millisecondsSinceEpoch);
    analytics.log('ad_shown', {'type': 'interstitial', 'placement': placement});
    await ad.show();
  }

  /// Shows the preloaded rewarded ad and returns whether the reward was earned.
  Future<bool> showRewarded({required String placement}) async {
    final ad = rewardedAd;
    if (ad == null) {
      analytics.log('ad_failed', {'type': 'rewarded', 'placement': placement, 'code': 'not_loaded'});
      return false;
    }
    rewardedAd = null;
    analytics.log('rewarded_opened', {'placement': placement});

    var earned = false;
    final completer = <bool>[];
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (dismissed) {
        dismissed.dispose();
        preloadRewarded();
      },
      onAdFailedToShowFullScreenContent: (failed, error) {
        failed.dispose();
        preloadRewarded();
      },
    );
    await ad.show(
      onUserEarnedReward: (adWithReward, reward) {
        earned = true;
      },
    );
    if (earned) analytics.log('rewarded_completed', {'placement': placement});
    return earned;
  }

  Future<void> showAppOpenIfAvailable() async {
    final ad = appOpenAd;
    if (ad == null) return;
    appOpenAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (dismissed) {
        dismissed.dispose();
        preloadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (failed, error) {
        failed.dispose();
        preloadAppOpen();
      },
    );
    await KeyValueStore.set(HiveService.adMetaBox, 'lastAppOpenAt', DateTime.now().millisecondsSinceEpoch);
    analytics.log('ad_shown', {'type': 'appOpen'});
    await ad.show();
  }

  /// A banner for use in menu screens only — never during gameplay.
  Widget bannerWidget({String placement = 'menu'}) {
    final cached = bannerAds[placement];
    if (cached != null) {
      return SizedBox(
        width: cached.size.width.toDouble(),
        height: cached.size.height.toDouble(),
        child: AdWidget(ad: cached),
      );
    }
    final banner = BannerAd(
      adUnitId: platformAdUnitId(units.banner),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (failed, error) {
          failed.dispose();
          bannerAds.remove(placement);
        },
      ),
    )..load();
    bannerAds[placement] = banner;
    return SizedBox(
      width: AdSize.banner.width.toDouble(),
      height: AdSize.banner.height.toDouble(),
      child: AdWidget(ad: banner),
    );
  }

  @override
  void onClose() {
    interstitialAd?.dispose();
    rewardedAd?.dispose();
    appOpenAd?.dispose();
    for (final banner in bannerAds.values) {
      banner.dispose();
    }
    super.onClose();
  }
}
