import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/config/mergoEconomy.dart';
import '../../../core/routing/appRoutes.dart';
import '../data/model/mergoTileColors.dart';
import '../data/model/swipeDirection.dart';

const int gridDimension = 4;
const int cellCount = gridDimension * gridDimension;
const List<int> milestoneValues = [512, 1024, 2048];

/// Owns the whole Mergo round: the 4x4 grid, swipe/merge/spawn, scoring,
/// undo, hammer, and Game Over (GAME_IDEAS.md §6.2/§6.9).
class GameController extends GetxController {
  final RxList<int> cells = List<int>.filled(cellCount, 0).obs;
  final RxInt score = 0.obs;
  final RxInt best = 0.obs;
  final RxInt bestTile = 0.obs;
  final RxBool hammerModeActive = false.obs;
  final RxList<FloatingScoreText> floatingTexts = <FloatingScoreText>[].obs;
  final RxList<ParticleBurst> bursts = <ParticleBurst>[].obs;
  final RxInt shakeTrigger = 0.obs;

  List<int>? lastGridForUndo;
  final Set<int> milestonesReachedThisRun = {};
  bool reviveUsed = false;
  final Random random = Random();

  late final GameSessionFlow sessionFlow;
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();
  final WalletService wallet = Get.find<WalletService>();
  final AdService ads = Get.find<AdService>();

  @override
  void onInit() {
    super.onInit();
    sessionFlow = GameSessionFlow(gameId: 'mergo', economyConfig: mergoEconomy);
    best.value = sessionFlow.bestScore;
    spawnTile();
    spawnTile();
    maybeShowTutorial();
  }

  void maybeShowTutorial() {
    if (KeyValueStore.get(HiveService.settingsBox, 'tutorialSeenMergo', false)) return;
    KeyValueStore.set(HiveService.settingsBox, 'tutorialSeenMergo', true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        HowToPlayDialog(game: 'mergo', goal: 'tutorialGoal'.tr, controls: 'tutorialControls'.tr, onGotIt: Get.back),
        barrierDismissible: false,
      );
    });
  }

  void spawnTile() {
    final emptyIndexes = [for (var i = 0; i < cellCount; i++) if (cells[i] == 0) i];
    if (emptyIndexes.isEmpty) return;
    final index = emptyIndexes[random.nextInt(emptyIndexes.length)];
    cells[index] = random.nextDouble() < 0.9 ? 2 : 4;
  }

  List<int> rowAt(List<int> grid, int row) => List.generate(gridDimension, (col) => grid[row * gridDimension + col]);

  List<int> colAt(List<int> grid, int col) => List.generate(gridDimension, (row) => grid[row * gridDimension + col]);

  void setRow(List<int> grid, int row, List<int> values) {
    for (var col = 0; col < gridDimension; col++) {
      grid[row * gridDimension + col] = values[col];
    }
  }

  void setCol(List<int> grid, int col, List<int> values) {
    for (var row = 0; row < gridDimension; row++) {
      grid[row * gridDimension + col] = values[row];
    }
  }

  (List<int> merged, int gained) mergeLine(List<int> line) {
    final nonZero = line.where((value) => value != 0).toList();
    final merged = <int>[];
    var gained = 0;
    var i = 0;
    while (i < nonZero.length) {
      if (i + 1 < nonZero.length && nonZero[i] == nonZero[i + 1]) {
        final mergedValue = nonZero[i] * 2;
        merged.add(mergedValue);
        gained += mergedValue;
        i += 2;
      } else {
        merged.add(nonZero[i]);
        i += 1;
      }
    }
    while (merged.length < line.length) {
      merged.add(0);
    }
    return (merged, gained);
  }

  Future<void> swipe(SwipeDirection direction) async {
    if (hammerModeActive.value) return;
    final newGrid = List<int>.from(cells);
    var gained = 0;
    final reversed = direction == SwipeDirection.right || direction == SwipeDirection.down;
    final horizontal = direction == SwipeDirection.left || direction == SwipeDirection.right;

    for (var i = 0; i < gridDimension; i++) {
      var line = horizontal ? rowAt(newGrid, i) : colAt(newGrid, i);
      if (reversed) line = line.reversed.toList();
      final (merged, lineGained) = mergeLine(line);
      var result = merged;
      if (reversed) result = result.reversed.toList();
      if (horizontal) {
        setRow(newGrid, i, result);
      } else {
        setCol(newGrid, i, result);
      }
      gained += lineGained;
    }

    final changed = List.generate(cellCount, (i) => cells[i]).toString() != newGrid.toString();
    if (!changed) return;

    lastGridForUndo = List<int>.from(cells);
    cells.assignAll(newGrid);
    if (gained > 0) {
      score.value += gained;
      await audio.playSfx('merge');
      await haptics.pulse(HapticPattern.medium);
      showFloatingText('+$gained');
      spawnBurst(MergoTileColors.colorFor(newGrid.reduce(max)));
      await checkMilestones();
    } else {
      await audio.playSfx('swipe');
      await haptics.pulse(HapticPattern.light);
    }

    final highestTile = cells.reduce(max);
    if (highestTile > bestTile.value) bestTile.value = highestTile;

    spawnTile();
    checkGameOver();
  }

  Future<void> checkMilestones() async {
    final highestTile = cells.reduce(max);
    for (final milestone in milestoneValues) {
      if (highestTile >= milestone && milestonesReachedThisRun.add(milestone)) {
        await audio.playSfx('milestone');
        await haptics.pulse(HapticPattern.doublePulse);
        showFloatingText('${'labelMilestone'.tr} $milestone');
        shakeTrigger.value++;
        await wallet.earn(milestone ~/ 10, source: 'milestone_$milestone');
      }
    }
  }

  void showFloatingText(String text) {
    final id = DateTime.now().microsecondsSinceEpoch;
    floatingTexts.add(FloatingScoreText(id: id, text: text));
    Future.delayed(const Duration(milliseconds: 1100), () {
      floatingTexts.removeWhere((entry) => entry.id == id);
    });
  }

  void spawnBurst(Color color) {
    final id = DateTime.now().microsecondsSinceEpoch;
    bursts.add(ParticleBurst(id: id, color: color));
    Future.delayed(const Duration(milliseconds: 500), () {
      bursts.removeWhere((burst) => burst.id == id);
    });
  }

  Future<void> undo() async {
    if (lastGridForUndo == null) return;
    final earned = await ads.showRewarded('undo');
    if (earned) {
      cells.assignAll(lastGridForUndo!);
      lastGridForUndo = null;
    }
  }

  Future<void> activateHammer() async {
    final earned = await ads.showRewarded('hammer');
    if (earned) hammerModeActive.value = true;
  }

  void onTileTap(int index) {
    if (!hammerModeActive.value || cells[index] == 0) return;
    cells[index] = 0;
    hammerModeActive.value = false;
    checkGameOver();
  }

  bool isGameOver() {
    if (cells.contains(0)) return false;
    for (var row = 0; row < gridDimension; row++) {
      for (var col = 0; col < gridDimension; col++) {
        final value = cells[row * gridDimension + col];
        if (col + 1 < gridDimension && cells[row * gridDimension + col + 1] == value) return false;
        if (row + 1 < gridDimension && cells[(row + 1) * gridDimension + col] == value) return false;
      }
    }
    return true;
  }

  void checkGameOver() {
    if (isGameOver()) gameOver();
  }

  Future<void> gameOver() async {
    await sessionFlow.showGameOver(
      result: GameResult(score: score.value),
      reviveAvailable: !reviveUsed,
      onRevive: () async => revive(),
      onRetry: () async => restart(),
      onHome: () async => Get.offAllNamed(AppRoutes.home),
    );
  }

  void revive() {
    reviveUsed = true;
    final filledIndexes = [for (var i = 0; i < cellCount; i++) if (cells[i] != 0) i]
      ..sort((a, b) => cells[a].compareTo(cells[b]));
    for (final index in filledIndexes.take((filledIndexes.length / 2).ceil())) {
      cells[index] = 0;
    }
    checkGameOver();
  }

  void restart() {
    cells.assignAll(List<int>.filled(cellCount, 0));
    score.value = 0;
    reviveUsed = false;
    lastGridForUndo = null;
    milestonesReachedThisRun.clear();
    best.value = sessionFlow.bestScore;
    spawnTile();
    spawnTile();
  }
}
