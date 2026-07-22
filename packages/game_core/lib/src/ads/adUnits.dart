import 'adUnitPair.dart';

/// The four ad-format unit IDs one game needs, per platform (GAME_IDEAS.md §3.5).
class AdUnits {
  const AdUnits({
    this.appOpen = const AdUnitPair(
      android: 'ca-app-pub-3940256099942544/9257395921',
      ios: 'ca-app-pub-3940256099942544/9257395921',
    ),
    this.interstitial = const AdUnitPair(
      android: 'ca-app-pub-3940256099942544/1033173712',
      ios: 'ca-app-pub-3940256099942544/1033173712',
    ),
    this.rewarded = const AdUnitPair(
      android: 'ca-app-pub-3940256099942544/5224354917',
      ios: 'ca-app-pub-3940256099942544/5224354917',
    ),
    this.banner = const AdUnitPair(
      android: 'ca-app-pub-3940256099942544/6300978111',
      ios: 'ca-app-pub-3940256099942544/6300978111',
    ),
  });

  final AdUnitPair appOpen;
  final AdUnitPair interstitial;
  final AdUnitPair rewarded;
  final AdUnitPair banner;
}
