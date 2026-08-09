import 'acquireMethod.dart';

/// A purchasable/earnable bundle of gems shown in the store's Gems tab
/// (GAME_IDEAS.md §3.11.4).
class GemPack {
  const GemPack({
    required this.id,
    required this.amount,
    required this.method,
    this.badge,
    this.cooldown = const Duration(seconds: 45),
    this.dailyLimit = 20,
  });

  final String id;
  final int amount;
  final AcquireMethod method;
  final String? badge;
  final Duration cooldown;
  final int dailyLimit;
}
