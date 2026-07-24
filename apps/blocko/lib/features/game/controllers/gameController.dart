import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/config/blockoEconomy.dart';
import '../../../core/routing/appRoutes.dart';
import '../data/model/blockoColors.dart';
import '../data/model/blockoShapeType.dart';
import '../data/model/blockoShapes.dart';

const int gridWidth = 10;
const int gridHeight = 20;
const int cellCount = gridWidth * gridHeight;

/// Owns the whole Blocko round: the 10x20 well, the falling piece, gravity,
/// row clearing, scoring, the difficulty ramp, and Game Over.
class GameController extends GetxController {
  final RxList<int> cells = List<int>.filled(cellCount, 0).obs;
  final RxInt score = 0.obs;
  final RxInt best = 0.obs;
  final RxSet<int> clearingRows = <int>{}.obs;
  final RxList<FloatingScoreText> floatingTexts = <FloatingScoreText>[].obs;
  final RxList<ParticleBurst> bursts = <ParticleBurst>[].obs;
  final RxInt shakeTrigger = 0.obs;

  final Rx<BlockoShapeType?> fallingType = Rx<BlockoShapeType?>(null);
  final RxInt fallingRotation = 0.obs;
  final RxInt fallingRow = 0.obs;
  final RxInt fallingCol = 0.obs;
  final RxInt fallingSpawnId = 0.obs;

  static const double swipeThreshold = 32;
  static const int baseDropIntervalMs = 800;
  static const int minDropIntervalMs = 150;
  static const int dropIntervalStepMs = 20;

  int linesClearedTotal = 0;
  double swipeAccumulator = 0;
  bool roundOver = false;
  bool reviveUsed = false;
  Timer? dropTimer;
  final Random random = Random();

  late final GameSessionFlow sessionFlow;
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  @override
  void onInit() {
    super.onInit();
    sessionFlow = GameSessionFlow(gameId: 'blocko', economyConfig: blockoEconomy);
    best.value = sessionFlow.bestScore;
    spawnPiece();
    scheduleNextDrop();
    maybeShowTutorial();
  }

  @override
  void onClose() {
    dropTimer?.cancel();
    super.onClose();
  }

  void maybeShowTutorial() {
    if (KeyValueStore.get(HiveService.settingsBox, 'tutorialSeenBlocko', false)) return;
    KeyValueStore.set(HiveService.settingsBox, 'tutorialSeenBlocko', true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        HowToPlayDialog(game: 'blocko', goal: 'tutorialGoal'.tr, controls: 'tutorialControls'.tr, onGotIt: Get.back),
        barrierDismissible: false,
      );
    });
  }

  int dropIntervalMs() =>
      (baseDropIntervalMs - linesClearedTotal * dropIntervalStepMs).clamp(minDropIntervalMs, baseDropIntervalMs);

  void scheduleNextDrop() {
    dropTimer?.cancel();
    if (roundOver) return;
    dropTimer = Timer(Duration(milliseconds: dropIntervalMs()), tick);
  }

  void spawnPiece() {
    final type = BlockoShapeType.values[random.nextInt(BlockoShapeType.values.length)];
    final box = BlockoShapes.boxSize[type]!;
    final anchorCol = (gridWidth - box) ~/ 2;
    if (!canPlace(type, 0, 0, anchorCol)) {
      gameOver();
      return;
    }
    fallingType.value = type;
    fallingRotation.value = 0;
    fallingRow.value = 0;
    fallingCol.value = anchorCol;
    fallingSpawnId.value++;
  }

  bool canPlace(BlockoShapeType type, int rotation, int anchorRow, int anchorCol) {
    for (final cell in BlockoShapes.cellsFor(type, rotation)) {
      final row = anchorRow + cell.x;
      final col = anchorCol + cell.y;
      if (row < 0 || row >= gridHeight || col < 0 || col >= gridWidth) return false;
      if (cells[row * gridWidth + col] != 0) return false;
    }
    return true;
  }

  /// Accumulates raw horizontal swipe distance (from anywhere on screen)
  /// into discrete one-column moves.
  void handleSwipeDelta(double dx) {
    if (roundOver) return;
    swipeAccumulator += dx;
    while (swipeAccumulator > swipeThreshold) {
      swipeAccumulator -= swipeThreshold;
      moveHorizontal(1);
    }
    while (swipeAccumulator < -swipeThreshold) {
      swipeAccumulator += swipeThreshold;
      moveHorizontal(-1);
    }
  }

  void resetSwipeAccumulator() => swipeAccumulator = 0;

  void moveHorizontal(int direction) {
    final type = fallingType.value;
    if (type == null) return;
    final newCol = fallingCol.value + direction;
    if (canPlace(type, fallingRotation.value, fallingRow.value, newCol)) {
      fallingCol.value = newCol;
    }
  }

  /// Rotates 90° clockwise; if the rotated shape doesn't fit, nudges one
  /// column either way before giving up (a minimal wall kick).
  void rotate() {
    final type = fallingType.value;
    if (type == null) return;
    final newRotation = (fallingRotation.value + 1) % 4;
    final anchorRow = fallingRow.value;
    final anchorCol = fallingCol.value;
    for (final kick in [0, 1, -1]) {
      if (canPlace(type, newRotation, anchorRow, anchorCol + kick)) {
        fallingRotation.value = newRotation;
        fallingCol.value = anchorCol + kick;
        return;
      }
    }
  }

  Future<void> tick() async {
    final type = fallingType.value;
    if (type == null || roundOver) return;
    final newRow = fallingRow.value + 1;
    if (canPlace(type, fallingRotation.value, newRow, fallingCol.value)) {
      fallingRow.value = newRow;
      scheduleNextDrop();
    } else {
      await lockPiece();
    }
  }

  Future<void> lockPiece() async {
    final type = fallingType.value;
    if (type == null) return;
    for (final cell in BlockoShapes.cellsFor(type, fallingRotation.value)) {
      final row = fallingRow.value + cell.x;
      final col = fallingCol.value + cell.y;
      cells[row * gridWidth + col] = type.index + 1;
    }
    fallingType.value = null;
    await audio.playSfx('place');
    await haptics.pulse(HapticPattern.light);

    await checkLineClears();
    if (roundOver) return;
    spawnPiece();
    scheduleNextDrop();
  }

  Future<void> checkLineClears() async {
    final fullRows = <int>[];
    for (var row = 0; row < gridHeight; row++) {
      final rowStart = row * gridWidth;
      final isFull = cells.getRange(rowStart, rowStart + gridWidth).every((value) => value != 0);
      if (isFull) fullRows.add(row);
    }
    if (fullRows.isEmpty) return;

    clearingRows.assignAll(fullRows);
    await audio.playSfx('clear');
    await haptics.pulse(fullRows.length >= 2 ? HapticPattern.doublePulse : HapticPattern.medium);
    await Future.delayed(const Duration(milliseconds: 220));

    final newCells = List<int>.filled(cellCount, 0);
    var writeRow = gridHeight - 1;
    for (var row = gridHeight - 1; row >= 0; row--) {
      if (fullRows.contains(row)) continue;
      for (var col = 0; col < gridWidth; col++) {
        newCells[writeRow * gridWidth + col] = cells[row * gridWidth + col];
      }
      writeRow--;
    }
    cells.assignAll(newCells);
    clearingRows.clear();

    linesClearedTotal += fullRows.length;
    final bonus = fullRows.length * 100;
    score.value += bonus;
    showFloatingText('+$bonus');
    spawnBurst(BlockoColors.palette[linesClearedTotal % BlockoColors.palette.length]);
    if (fullRows.length >= 2) shakeTrigger.value++;
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

  Future<void> gameOver() async {
    roundOver = true;
    dropTimer?.cancel();
    fallingType.value = null;
    shakeTrigger.value++;
    await sessionFlow.showGameOver(
      result: GameResult(score: score.value),
      reviveAvailable: !reviveUsed,
      onRevive: () async => revive(),
      onRetry: () async => restart(),
      onHome: () async => Get.offAllNamed(AppRoutes.home),
    );
  }

  /// Clears the top 4 rows to make room for a fresh spawn, then resumes.
  void revive() {
    reviveUsed = true;
    final newCells = List<int>.from(cells);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < gridWidth; col++) {
        newCells[row * gridWidth + col] = 0;
      }
    }
    cells.assignAll(newCells);
    roundOver = false;
    spawnPiece();
    scheduleNextDrop();
  }

  void restart() {
    cells.assignAll(List<int>.filled(cellCount, 0));
    score.value = 0;
    linesClearedTotal = 0;
    roundOver = false;
    reviveUsed = false;
    best.value = sessionFlow.bestScore;
    spawnPiece();
    scheduleNextDrop();
  }
}
