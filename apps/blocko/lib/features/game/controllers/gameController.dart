import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/config/blockoEconomy.dart';
import '../../../core/routing/appRoutes.dart';
import '../data/model/blockoColors.dart';
import '../data/model/blockoLandingFlash.dart';
import '../data/model/blockoShapeType.dart';
import '../data/model/blockoShapes.dart';
import '../data/model/blockoShiftingCell.dart';

const int gridWidth = 20;

/// The well's row count — fixed width (20), but the height is computed once
/// from the actual available screen space (see `BoardWidget` /
/// `GameController.configureBoardHeight`) so the board always fills the
/// device's screen instead of assuming a fixed shape. This fallback is only
/// ever visible for the first, pre-layout frame.
int gridHeight = 36;

int get cellCount => gridWidth * gridHeight;

/// Owns the whole Blocko round: the well, the falling piece, gravity, row
/// clearing, scoring, the difficulty ramp, and Game Over.
class GameController extends GetxController {
  final RxList<int> cells = List<int>.filled(cellCount, 0).obs;
  final RxInt score = 0.obs;
  final RxInt best = 0.obs;
  final RxSet<int> clearingRows = <int>{}.obs;
  final RxInt clearEventId = 0.obs;
  final RxList<FloatingScoreText> floatingTexts = <FloatingScoreText>[].obs;
  final RxList<ParticleBurst> bursts = <ParticleBurst>[].obs;
  final RxInt shakeTrigger = 0.obs;
  final RxInt glowTrigger = 0.obs;
  final RxBool glowBig = false.obs;
  final RxList<BlockoLandingFlash> landingFlashes = <BlockoLandingFlash>[].obs;
  final RxList<BlockoShiftingCell> shiftingCells = <BlockoShiftingCell>[].obs;
  final RxBool shiftSettled = false.obs;
  final RxInt shiftEventId = 0.obs;
  final RxBool paused = false.obs;
  final RxBool menuOpen = false.obs;
  final RxBool fastDropping = false.obs;

  final Rx<BlockoShapeType?> fallingType = Rx<BlockoShapeType?>(null);
  final RxInt fallingRotation = 0.obs;
  final RxInt fallingRow = 0.obs;
  final RxInt fallingCol = 0.obs;
  final RxInt fallingSpawnId = 0.obs;

  static const double swipeThreshold = 32;
  static const double fastDropCells = 7;
  static const int baseDropIntervalMs = 800;
  static const int minDropIntervalMs = 150;
  static const int fastDropIntervalMs = 40;
  static const int dropIntervalStepMs = 20;
  static const int shatterDurationMs = 260;
  static const int shiftDurationMs = 200;

  int linesClearedTotal = 0;
  double swipeAccumulator = 0;
  double verticalAccumulator = 0;
  bool roundOver = false;
  bool reviveUsed = false;
  bool boardConfigured = false;
  // Real on-screen cell size in logical pixels, set once from the board's
  // actual layout — the fast-drop gesture threshold scales off this instead
  // of a fixed pixel count, so it always means "drag down ~7 cells" no
  // matter the device's screen density.
  double cellSizePx = 20;

  double get fastDropThreshold => cellSizePx * fastDropCells;
  Timer? dropTimer;
  Timer? watchdogTimer;
  final Random random = Random();

  late final GameSessionFlow sessionFlow;
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  @override
  void onInit() {
    super.onInit();
    sessionFlow = GameSessionFlow(gameId: 'blocko', economyConfig: blockoEconomy);
    best.value = sessionFlow.bestScore;
    // Belt-and-suspenders: if a piece is falling and play is live but gravity's
    // timer somehow died (a stalled browser tab, a suspended audio/haptics
    // call, or any other silent hiccup), this catches it within a second
    // instead of leaving the piece frozen in place forever.
    watchdogTimer = Timer.periodic(const Duration(seconds: 1), (_) => _watchdogCheck());
  }

  void _watchdogCheck() {
    if (!roundOver && !paused.value && !menuOpen.value && fallingType.value != null && (dropTimer == null || !dropTimer!.isActive)) {
      scheduleNextDrop();
    }
  }

  @override
  void onClose() {
    dropTimer?.cancel();
    watchdogTimer?.cancel();
    super.onClose();
  }

  /// Called once by `BoardWidget` after its first layout, with however many
  /// square rows actually fit the device's screen at the fixed 20-wide cell
  /// size — only the very first call takes effect.
  void configureBoardHeight(int rows, double cellSize) {
    if (boardConfigured) return;
    boardConfigured = true;
    gridHeight = rows.clamp(10, 200);
    cellSizePx = cellSize;
    cells.assignAll(List<int>.filled(cellCount, 0));
    spawnPiece();
    scheduleNextDrop();
    maybeShowTutorial();
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

  int dropIntervalMs() => fastDropping.value
      ? fastDropIntervalMs
      : (baseDropIntervalMs - linesClearedTotal * dropIntervalStepMs).clamp(minDropIntervalMs, baseDropIntervalMs);

  void scheduleNextDrop() {
    dropTimer?.cancel();
    if (roundOver || paused.value || menuOpen.value) return;
    dropTimer = Timer(Duration(milliseconds: dropIntervalMs()), tick);
  }

  /// Freezes/resumes gravity — the hamburger menu's Pause row and the
  /// full-screen Paused overlay's Resume button both call this.
  void togglePause() {
    paused.value = !paused.value;
    menuOpen.value = false;
    if (paused.value) {
      dropTimer?.cancel();
    } else {
      scheduleNextDrop();
    }
  }

  void toggleMenu() {
    menuOpen.value = !menuOpen.value;
    if (menuOpen.value) {
      dropTimer?.cancel();
    } else if (!paused.value) {
      scheduleNextDrop();
    }
  }

  void exitGame() {
    menuOpen.value = false;
    dropTimer?.cancel();
    Get.offAllNamed(AppRoutes.home);
  }

  void spawnPiece() {
    // A fresh piece always starts at normal speed — a drag held across two
    // piece drops must not carry its "already past the fast-drop threshold"
    // accumulator into the next piece, or it instantly free-falls too.
    verticalAccumulator = 0;
    swipeAccumulator = 0;
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

  /// Accumulates a drag delta from anywhere on the board into discrete
  /// one-column horizontal moves, and engages fast-drop once the drag goes
  /// far enough downward.
  void handlePanUpdate(Offset delta) {
    if (roundOver || paused.value || menuOpen.value) return;
    swipeAccumulator += delta.dx;
    while (swipeAccumulator > swipeThreshold) {
      swipeAccumulator -= swipeThreshold;
      moveHorizontal(1);
    }
    while (swipeAccumulator < -swipeThreshold) {
      swipeAccumulator += swipeThreshold;
      moveHorizontal(-1);
    }

    verticalAccumulator += delta.dy;
    if (verticalAccumulator > fastDropThreshold && !fastDropping.value) {
      fastDropping.value = true;
      scheduleNextDrop();
    }
  }

  /// A downward drag commits the current piece to fast-drop for the rest
  /// of its fall — lifting the finger does not cancel it. Only locking the
  /// piece (see `lockPiece`) turns fast-drop back off, for the next piece.
  void handlePanEnd() {
    swipeAccumulator = 0;
    verticalAccumulator = 0;
  }

  void moveHorizontal(int direction) {
    final type = fallingType.value;
    if (type == null) return;
    final newCol = fallingCol.value + direction;
    if (canPlace(type, fallingRotation.value, fallingRow.value, newCol)) {
      fallingCol.value = newCol;
      haptics.pulse(HapticPattern.light);
    }
  }

  /// Rotates 90° clockwise; if the rotated shape doesn't fit, nudges one
  /// column either way before giving up (a minimal wall kick). Returns
  /// whether the rotation actually happened, so callers can gate feedback
  /// (sound/haptic) on a real rotation rather than a no-op tap.
  bool rotate() {
    final type = fallingType.value;
    if (type == null) return false;
    final newRotation = (fallingRotation.value + 1) % 4;
    final anchorRow = fallingRow.value;
    final anchorCol = fallingCol.value;
    for (final kick in [0, 1, -1]) {
      if (canPlace(type, newRotation, anchorRow, anchorCol + kick)) {
        fallingRotation.value = newRotation;
        fallingCol.value = anchorCol + kick;
        return true;
      }
    }
    return false;
  }

  /// Tap-anywhere-to-rotate: the board's whole play area is one big rotate
  /// button, so it carries the same feedback a real button would have had.
  void rotateFromTap() {
    if (roundOver || paused.value || menuOpen.value) return;
    if (rotate()) {
      audio.playSfx('tap');
      haptics.pulse(HapticPattern.light);
    }
  }

  Future<void> tick() async {
    final type = fallingType.value;
    if (type == null || roundOver || paused.value || menuOpen.value) return;
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
    fastDropping.value = false;
    final landedIndexes = <int>[];
    for (final cell in BlockoShapes.cellsFor(type, fallingRotation.value)) {
      final row = fallingRow.value + cell.x;
      final col = fallingCol.value + cell.y;
      final index = row * gridWidth + col;
      cells[index] = type.index + 1;
      landedIndexes.add(index);
    }
    fallingType.value = null;
    spawnLandingFlash(landedIndexes);
    await audio.playSfx('place');
    await haptics.pulse(HapticPattern.light);

    await checkLineClears();
    if (roundOver) return;
    spawnPiece();
    scheduleNextDrop();
  }

  void spawnLandingFlash(List<int> cellIndexes) {
    final id = DateTime.now().microsecondsSinceEpoch;
    landingFlashes.add(BlockoLandingFlash(id: id, cellIndexes: cellIndexes));
    Future.delayed(const Duration(milliseconds: 260), () {
      landingFlashes.removeWhere((flash) => flash.id == id);
    });
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
    clearEventId.value++;
    await audio.playSfx('clear');
    await haptics.pulse(fullRows.length >= 2 ? HapticPattern.doublePulse : HapticPattern.light);
    await Future.delayed(const Duration(milliseconds: shatterDurationMs));

    final newCells = List<int>.filled(cellCount, 0);
    final shifted = <BlockoShiftingCell>[];
    final settledRows = <int>{};
    var writeRow = gridHeight - 1;
    for (var row = gridHeight - 1; row >= 0; row--) {
      if (fullRows.contains(row)) continue;
      if (row != writeRow) {
        settledRows.add(writeRow);
        for (var col = 0; col < gridWidth; col++) {
          final value = cells[row * gridWidth + col];
          if (value != 0) {
            shifted.add(BlockoShiftingCell(fromIndex: row * gridWidth + col, toIndex: writeRow * gridWidth + col, colorValue: value));
          }
        }
      }
      for (var col = 0; col < gridWidth; col++) {
        newCells[writeRow * gridWidth + col] = cells[row * gridWidth + col];
      }
      writeRow--;
    }
    clearingRows.clear();

    if (shifted.isNotEmpty) {
      final gridWithGapsCleared = List<int>.from(cells);
      for (final shift in shifted) {
        gridWithGapsCleared[shift.fromIndex] = 0;
      }
      cells.assignAll(gridWithGapsCleared);
      shiftSettled.value = false;
      shiftingCells.assignAll(shifted);
      shiftEventId.value++;
      await Future.delayed(const Duration(milliseconds: 16));
      shiftSettled.value = true;
      await Future.delayed(const Duration(milliseconds: shiftDurationMs));
      shiftingCells.clear();

      final flashIndexes = <int>[];
      for (final row in settledRows) {
        for (var col = 0; col < gridWidth; col++) {
          final index = row * gridWidth + col;
          if (newCells[index] != 0) flashIndexes.add(index);
        }
      }
      spawnLandingFlash(flashIndexes);
    }
    cells.assignAll(newCells);

    linesClearedTotal += fullRows.length;
    final bonus = fullRows.length * 100;
    score.value += bonus;
    showFloatingText('+$bonus');
    spawnBurst(BlockoColors.palette[linesClearedTotal % BlockoColors.palette.length]);
    glowBig.value = fullRows.length >= 2;
    glowTrigger.value++;
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
    paused.value = false;
    menuOpen.value = false;
    fastDropping.value = false;
    best.value = sessionFlow.bestScore;
    spawnPiece();
    scheduleNextDrop();
  }
}
