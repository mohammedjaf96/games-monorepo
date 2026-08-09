import 'package:get/get.dart';

import '../../analytics/analyticsService.dart';
import '../../storage/hiveService.dart';
import '../../storage/keyValueStore.dart';
import '../walletService.dart';
import 'dailyRewardConfig.dart';
import 'dayReward.dart';

/// A prize for every new calendar day the app is opened, with a 7-day
/// escalating streak (GAME_IDEAS.md §3.12). Missing a day resets the streak.
class DailyRewardService extends GetxService {
  DailyRewardService(this.config);

  final DailyRewardConfig config;
  final WalletService wallet = Get.find<WalletService>();
  final AnalyticsService analytics = Get.find<AnalyticsService>();

  final RxInt streak = 1.obs;

  Future<DailyRewardService> init() async {
    streak.value = KeyValueStore.get(HiveService.economyBox, 'dailyStreak', 1);
    return this;
  }

  int get currentDay => ((streak.value - 1) % config.days.length) + 1;

  bool get canClaimToday {
    final lastClaimDate = KeyValueStore.get<String?>(HiveService.economyBox, 'lastDailyClaimDate', null);
    return lastClaimDate != todayKey();
  }

  /// The reward the player would receive if they claimed right now.
  DayReward get pendingReward => config.days[currentDay - 1];

  Future<void> claim({bool doubled = false}) async {
    if (!canClaimToday) return;

    final lastClaimDateStr = KeyValueStore.get<String?>(HiveService.economyBox, 'lastDailyClaimDate', null);
    if (didMissADay(lastClaimDateStr)) {
      streak.value = 1;
      analytics.log('daily_streak_broken');
    }

    final reward = pendingReward;
    final claimedDay = currentDay;
    final gems = doubled ? reward.gems * 2 : reward.gems;
    if (gems > 0) await wallet.earn(gems, source: 'daily_reward');

    await KeyValueStore.set(HiveService.economyBox, 'lastDailyClaimDate', todayKey());
    final nextStreak = streak.value >= config.days.length ? 1 : streak.value + 1;
    streak.value = nextStreak;
    await KeyValueStore.set(HiveService.economyBox, 'dailyStreak', nextStreak);
    analytics.log('daily_reward_claimed', {'day': claimedDay, 'doubled': doubled});
  }

  bool didMissADay(String? lastClaimDateStr) {
    if (lastClaimDateStr == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    return lastClaimDateStr != yesterdayKey && lastClaimDateStr != todayKey();
  }

  String todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
