import 'dayReward.dart';

/// The 7-day prize ladder supplied by each app (GAME_IDEAS.md §3.12.4).
class DailyRewardConfig {
  const DailyRewardConfig({required this.days});

  final List<DayReward> days;
}
