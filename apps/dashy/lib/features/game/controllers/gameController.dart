import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/config/dashyEconomy.dart';
import '../../../core/routing/appRoutes.dart';
import '../flame/dashyGame.dart';

/// Bridges the Flame game loop to GetX/UI: reactive distance/coins/best,
/// and the shared Game Over flow (GAME_IDEAS.md §5.9/§5.10).
class GameController extends GetxController {
  final RxDouble distance = 0.0.obs;
  final RxInt coins = 0.obs;
  final RxInt best = 0.obs;

  bool reviveUsed = false;

  late final DashyGame game;
  late final GameSessionFlow sessionFlow;
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  @override
  void onInit() {
    super.onInit();
    sessionFlow = GameSessionFlow(gameId: 'dashy', economyConfig: dashyEconomy);
    best.value = sessionFlow.bestScore;
    game = DashyGame(onScore: handleScore, onCoin: handleCoin, onDeath: handleDeath);
  }

  void handleScore(double newDistance) {
    distance.value = newDistance;
  }

  void handleCoin() {
    coins.value += 1;
    audio.playSfx('coin');
    haptics.pulse(HapticPattern.selection);
  }

  Future<void> handleDeath() async {
    await audio.playSfx('game_over');
    await haptics.pulse(HapticPattern.heavy);
    await gameOver();
  }

  Future<void> gameOver() async {
    await sessionFlow.showGameOver(
      result: GameResult(distance: distance.value, coinsThisRun: coins.value),
      reviveAvailable: !reviveUsed,
      onRevive: () async => revive(),
      onRetry: () async => restart(),
      onHome: () async => Get.offAllNamed(AppRoutes.home),
    );
  }

  void revive() {
    reviveUsed = true;
    game.reviveInPlace();
  }

  void restart() {
    reviveUsed = false;
    coins.value = 0;
    best.value = sessionFlow.bestScore;
    game.reset();
  }

  void pauseGame() => game.pauseEngine();

  void resumeGame() => game.resumeEngine();

  void openPauseMenu() {
    pauseGame();
    Get.dialog(
      PauseDialog(
        onResume: () {
          Get.back();
          resumeGame();
        },
        onRestart: () {
          Get.back();
          restart();
        },
        onHome: () => Get.offAllNamed(AppRoutes.home),
      ),
      barrierDismissible: false,
    );
  }
}
