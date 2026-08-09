/// Tunable interstitial frequency-capping rules (GAME_IDEAS.md §3.6).
class AdPolicy {
  const AdPolicy({
    this.minInterstitialGapSeconds = 45,
    this.interstitialEveryNGameOvers = 2,
    this.firstSessionGraceSeconds = 60,
    this.appOpenColdStart = true,
    this.appOpenOnResume = true,
    this.appOpenMinGapSeconds = 15,
  });

  final int minInterstitialGapSeconds;
  final int interstitialEveryNGameOvers;
  final int firstSessionGraceSeconds;
  final bool appOpenColdStart;
  final bool appOpenOnResume;
  final int appOpenMinGapSeconds;
}
