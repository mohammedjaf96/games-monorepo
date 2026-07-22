/// Per-platform AdMob unit IDs for one ad format. Defaults to Google's
/// official test IDs (GAME_IDEAS.md §3.5) — replace with real IDs in
/// `GameConfig.adUnits` before release.
class AdUnitPair {
  const AdUnitPair({required this.android, required this.ios});

  final String android;
  final String ios;
}
