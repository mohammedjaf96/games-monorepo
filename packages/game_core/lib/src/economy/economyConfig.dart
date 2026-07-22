import 'currencySkin.dart';
import 'dailyReward/dailyRewardConfig.dart';
import 'earnCaps.dart';
import 'gemPack.dart';
import 'gameResult.dart';

/// Per-app gem economy configuration (GAME_IDEAS.md §3.11.4/§3.11.9). The
/// engine lives once in `game_core`; only these values differ per game.
class EconomyConfig {
  const EconomyConfig({
    required this.currency,
    required this.baseWinReward,
    required this.winReward,
    required this.caps,
    this.doubleMultiplier = 2,
    this.gemPacks = const [],
    this.dailyReward,
  });

  final CurrencySkin currency;
  final int baseWinReward;
  final int Function(GameResult result) winReward;
  final int doubleMultiplier;
  final List<GemPack> gemPacks;
  final DailyRewardConfig? dailyReward;
  final EarnCaps caps;
}
