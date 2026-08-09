import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';
import 'gemPack.dart';

/// Anti-abuse limits on rewarded-ad gem earning (GAME_IDEAS.md §3.11.4).
/// Persists `dailyClaims`/`lastGemAdAt` in the `economy` Hive box and resets
/// the daily counters automatically at the start of a new calendar day.
class EarnCaps {
  const EarnCaps({
    this.maxRewardedGemClaimsPerDay = 20,
    this.globalGemAdCooldown = const Duration(seconds: 45),
  });

  final int maxRewardedGemClaimsPerDay;
  final Duration globalGemAdCooldown;

  bool canClaim(GemPack pack) {
    final now = DateTime.now();
    final lastGemAdAt = KeyValueStore.get(HiveService.economyBox, 'lastGemAdAt', 0);
    final secondsSinceLastAd = (now.millisecondsSinceEpoch - lastGemAdAt) / 1000;
    if (secondsSinceLastAd < globalGemAdCooldown.inSeconds) return false;
    if (secondsSinceLastAd < pack.cooldown.inSeconds) return false;

    final claims = dailyClaimsForToday();
    final totalToday = claims.values.fold<int>(0, (sum, count) => sum + count);
    if (totalToday >= maxRewardedGemClaimsPerDay) return false;

    final packClaimsToday = claims[pack.id] ?? 0;
    if (packClaimsToday >= pack.dailyLimit) return false;

    return true;
  }

  Future<void> markClaimed(GemPack pack) async {
    final now = DateTime.now();
    await KeyValueStore.set(HiveService.economyBox, 'lastGemAdAt', now.millisecondsSinceEpoch);

    final claims = dailyClaimsForToday();
    claims[pack.id] = (claims[pack.id] ?? 0) + 1;
    await KeyValueStore.set(HiveService.economyBox, 'dailyClaims', {
      'date': todayKey(),
      'countByPackId': claims,
    });
  }

  Map<String, int> dailyClaimsForToday() {
    final stored = KeyValueStore.get<Map>(HiveService.economyBox, 'dailyClaims', const {});
    if (stored['date'] != todayKey()) return {};
    final counts = stored['countByPackId'];
    if (counts is Map) {
      return counts.map((key, value) => MapEntry(key.toString(), value as int));
    }
    return {};
  }

  String todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
