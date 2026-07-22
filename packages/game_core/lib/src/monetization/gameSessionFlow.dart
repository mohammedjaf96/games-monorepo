import 'package:get/get.dart';

import '../ads/adService.dart';
import '../analytics/analyticsService.dart';
import '../audio/audioService.dart';
import '../audio/hapticPattern.dart';
import '../audio/hapticsService.dart';
import '../economy/economyConfig.dart';
import '../economy/gameResult.dart';
import '../economy/walletService.dart';
import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';
import '../ui/gameOverDialog.dart';

/// The shared "addiction + ads" loop every game runs at Game Over
/// (GAME_IDEAS.md §3.10): award gems, persist best/games-played, show the
/// dialog, then hand control back via one of the three provided callbacks.
class GameSessionFlow {
  GameSessionFlow({required this.gameId, required this.economyConfig});

  final String gameId;
  final EconomyConfig economyConfig;

  final WalletService wallet = Get.find<WalletService>();
  final AdService ads = Get.find<AdService>();
  final AnalyticsService analytics = Get.find<AnalyticsService>();
  final HapticsService haptics = Get.find<HapticsService>();
  final AudioService audio = Get.find<AudioService>();

  int get bestScore => KeyValueStore.get(HiveService.progressBox, 'bestScore_$gameId', 0);

  Future<void> showGameOver({
    required GameResult result,
    required bool reviveAvailable,
    required Future<void> Function() onRevive,
    required Future<void> Function() onRetry,
    required Future<void> Function() onHome,
  }) async {
    final previousBest = bestScore;
    final isNewRecord = result.score > previousBest;
    if (isNewRecord) {
      await KeyValueStore.set(HiveService.progressBox, 'bestScore_$gameId', result.score);
    }

    final totalGamesPlayed = KeyValueStore.get(HiveService.progressBox, 'totalGamesPlayed_$gameId', 0) + 1;
    await KeyValueStore.set(HiveService.progressBox, 'totalGamesPlayed_$gameId', totalGamesPlayed);

    final gameOverCounter = KeyValueStore.get(HiveService.adMetaBox, 'gameOverCounter', 0) + 1;
    await KeyValueStore.set(HiveService.adMetaBox, 'gameOverCounter', gameOverCounter);

    final gemsEarned = economyConfig.baseWinReward + economyConfig.winReward(result);
    await wallet.earn(gemsEarned, source: 'round_win');

    await audio.playSfx('game_over');
    await haptics.pulse(HapticPattern.heavy);
    if (isNewRecord) {
      await audio.playSfx('record');
      await haptics.pulse(HapticPattern.doublePulse);
    }

    analytics.log('game_over', {'game': gameId, 'score': result.score});
    if (isNewRecord) analytics.log('record_broken', {'game': gameId, 'score': result.score});

    await Get.dialog(
      GameOverDialog(
        game: gameId,
        score: result.score,
        best: isNewRecord ? result.score : previousBest,
        isNewRecord: isNewRecord,
        onRevive: reviveAvailable
            ? () async {
                final earned = await ads.showRewarded('revive');
                if (earned) {
                  Get.back();
                  await onRevive();
                }
              }
            : null,
        onDoubleCoins: () async {
          final earned = await ads.showRewarded('double_coins');
          if (earned) await wallet.earn(gemsEarned, source: 'double_coins');
        },
        onRetry: () async {
          Get.back();
          await ads.maybeShowInterstitial(placement: 'game_over');
          await onRetry();
        },
        onHome: () async {
          Get.back();
          await onHome();
        },
      ),
      barrierDismissible: false,
    );
  }
}
