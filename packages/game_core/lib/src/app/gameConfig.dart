import '../ads/adPolicy.dart';
import '../ads/adUnits.dart';
import '../economy/economyConfig.dart';
import '../store/storeCatalog.dart';

/// Everything one app must supply to `bootstrapGame` (GAME_IDEAS.md §3.2/§3.11.9).
class GameConfig {
  const GameConfig({
    required this.gameId,
    required this.adUnits,
    required this.economy,
    required this.storeCatalog,
    this.adPolicy = const AdPolicy(),
    this.privacyPolicyUrl,
  });

  final String gameId;
  final AdUnits adUnits;
  final AdPolicy adPolicy;
  final EconomyConfig economy;
  final StoreCatalog storeCatalog;

  /// Public URL to the privacy policy, shown as a link on the Settings
  /// screen. Required by Google Play/App Store review for any ad-supported app.
  final String? privacyPolicyUrl;
}
