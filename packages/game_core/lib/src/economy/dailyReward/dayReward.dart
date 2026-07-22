/// One day's prize within the 7-day daily-reward streak (GAME_IDEAS.md §3.12).
class DayReward {
  const DayReward({required this.gems, this.cosmeticId, this.isBig = false});

  final int gems;
  final String? cosmeticId;
  final bool isBig;
}
