/// The outcome of a single played round, used to compute the gem/coin reward
/// (GAME_IDEAS.md §3.11.4).
class GameResult {
  const GameResult({
    this.score = 0,
    this.comboStreak = 0,
    this.distance = 0,
    this.coinsThisRun = 0,
  });

  final int score;
  final int comboStreak;
  final double distance;
  final int coinsThisRun;
}
