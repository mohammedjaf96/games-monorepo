import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

/// The unified gem currency (identical across all three games — GAME_IDEAS.md §3.11.2).
const mergoCurrency = CurrencySkin(
  id: 'gem',
  nameKey: 'currencyName',
  assetIcon: 'assets/icons/gem.svg',
  color: Color(0xFFE886FF),
  glowColor: Color(0xFF9A2AE8),
);

/// Mergo's gem economy (GAME_IDEAS.md §6.6): reward scales with the sum of merges.
final EconomyConfig mergoEconomy = EconomyConfig(
  currency: mergoCurrency,
  baseWinReward: 3,
  winReward: (result) => result.score ~/ 100,
  caps: const EarnCaps(maxRewardedGemClaimsPerDay: 20, globalGemAdCooldown: Duration(seconds: 45)),
  gemPacks: const [
    GemPack(id: 'ad_25', amount: 25, method: AcquireMethod.ad, cooldown: Duration(seconds: 45), dailyLimit: 20),
  ],
  dailyReward: const DailyRewardConfig(
    days: [
      DayReward(gems: 20),
      DayReward(gems: 30),
      DayReward(gems: 40),
      DayReward(gems: 60),
      DayReward(gems: 80),
      DayReward(gems: 100),
      DayReward(gems: 200, isBig: true),
    ],
  ),
);
