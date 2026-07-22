import 'dart:math';

import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../../core/config/blockoEconomy.dart';
import '../../../core/routing/appRoutes.dart';
import '../data/model/blockoColors.dart';
import '../data/model/blockoPiece.dart';
import '../data/model/pieceShapes.dart';

const int gridSize = 8;
const int cellCount = gridSize * gridSize;

/// Owns the whole Blocko round: the 8x8 grid, the 3-piece tray, placement,
/// line clearing, scoring, and Game Over (GAME_IDEAS.md §4.2/§4.9).
class GameController extends GetxController {
  final RxList<int> cells = List<int>.filled(cellCount, 0).obs;
  final RxList<BlockoPiece?> tray = List<BlockoPiece?>.filled(3, null).obs;
  final RxInt score = 0.obs;
  final RxInt best = 0.obs;
  final RxInt comboStreak = 0.obs;
  final RxSet<int> previewCells = <int>{}.obs;
  final RxBool previewValid = false.obs;
  final Rx<String?> floatingText = Rx<String?>(null);

  bool reviveUsed = false;
  final Random random = Random();

  late final GameSessionFlow sessionFlow;
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  @override
  void onInit() {
    super.onInit();
    sessionFlow = GameSessionFlow(gameId: 'blocko', economyConfig: blockoEconomy);
    best.value = sessionFlow.bestScore;
    fillTrayIfEmpty();
  }

  void fillTrayIfEmpty() {
    if (tray.any((piece) => piece != null)) return;
    final avoidLarge = filledRatio() > 0.6;
    for (var i = 0; i < tray.length; i++) {
      tray[i] = generatePiece(avoidLarge: avoidLarge);
    }
    checkGameOver();
  }

  double filledRatio() => cells.where((cell) => cell != 0).length / cellCount;

  BlockoPiece generatePiece({required bool avoidLarge}) {
    final pool = avoidLarge ? PieceShapes.smallShapes() : PieceShapes.all;
    final shape = pool[random.nextInt(pool.length)];
    final colorIndex = random.nextInt(BlockoColors.palette.length);
    return BlockoPiece(id: '${DateTime.now().microsecondsSinceEpoch}_$colorIndex', cells: shape, colorIndex: colorIndex);
  }

  /// The grid indexes `piece` would occupy anchored at (`anchorRow`,
  /// `anchorCol`), or null if any cell is out of bounds or already filled.
  /// Pure — has no side effects on `previewCells`.
  Set<int>? targetIndexesFor(BlockoPiece piece, int anchorRow, int anchorCol) {
    final targetIndexes = <int>{};
    for (final cell in piece.cells) {
      final row = anchorRow + cell.x;
      final col = anchorCol + cell.y;
      if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return null;
      final index = row * gridSize + col;
      if (cells[index] != 0) return null;
      targetIndexes.add(index);
    }
    return targetIndexes;
  }

  bool fitsAt(BlockoPiece piece, int anchorRow, int anchorCol) =>
      targetIndexesFor(piece, anchorRow, anchorCol) != null;

  void commitPlacement(BlockoPiece piece, Set<int> targetIndexes) {
    for (final index in targetIndexes) {
      cells[index] = piece.colorIndex + 1;
    }
  }

  void updatePreview(BlockoPiece piece, int anchorRow, int anchorCol) {
    final targetIndexes = targetIndexesFor(piece, anchorRow, anchorCol);
    previewCells.value = targetIndexes ?? {};
    previewValid.value = targetIndexes != null;
  }

  void clearPreview() {
    previewCells.clear();
    previewValid.value = false;
  }

  Future<void> tryPlacePiece(int pieceIndex, int anchorRow, int anchorCol) async {
    final piece = tray[pieceIndex];
    clearPreview();
    if (piece == null) return;
    final targetIndexes = targetIndexesFor(piece, anchorRow, anchorCol);
    if (targetIndexes == null) {
      await audio.playSfx('error');
      await haptics.pulse(HapticPattern.medium);
      return;
    }
    commitPlacement(piece, targetIndexes);
    tray[pieceIndex] = null;
    score.value += piece.cells.length;
    await audio.playSfx('place');
    await haptics.pulse(HapticPattern.light);

    await checkLineClears();
    fillTrayIfEmpty();
    checkGameOver();
  }

  Future<void> checkLineClears() async {
    final fullRows = <int>[];
    final fullCols = <int>[];
    for (var row = 0; row < gridSize; row++) {
      if (List.generate(gridSize, (col) => cells[row * gridSize + col]).every((value) => value != 0)) {
        fullRows.add(row);
      }
    }
    for (var col = 0; col < gridSize; col++) {
      if (List.generate(gridSize, (row) => cells[row * gridSize + col]).every((value) => value != 0)) {
        fullCols.add(col);
      }
    }

    final linesCleared = fullRows.length + fullCols.length;
    if (linesCleared == 0) {
      comboStreak.value = 0;
      return;
    }

    for (final row in fullRows) {
      for (var col = 0; col < gridSize; col++) {
        cells[row * gridSize + col] = 0;
      }
    }
    for (final col in fullCols) {
      for (var row = 0; row < gridSize; row++) {
        cells[row * gridSize + col] = 0;
      }
    }

    comboStreak.value += 1;
    final clearedCells = linesCleared * gridSize;
    final bonus = clearedCells * comboStreak.value;
    score.value += bonus;
    showFloatingText(comboStreak.value > 1 ? 'Combo x${comboStreak.value}! +$bonus' : '+$bonus');

    await audio.playSfx('clear');
    final comboSfxIndex = comboStreak.value.clamp(1, 5);
    await audio.playSfx('combo_$comboSfxIndex');
    await haptics.pulse(comboStreak.value >= 3 ? HapticPattern.doublePulse : HapticPattern.medium);
  }

  void showFloatingText(String text) {
    floatingText.value = text;
    Future.delayed(const Duration(milliseconds: 900), () {
      if (floatingText.value == text) floatingText.value = null;
    });
  }

  bool pieceFitsAnywhere(BlockoPiece piece) {
    for (var row = 0; row < gridSize; row++) {
      for (var col = 0; col < gridSize; col++) {
        if (fitsAt(piece, row, col)) return true;
      }
    }
    return false;
  }

  void checkGameOver() {
    final remainingPieces = tray.whereType<BlockoPiece>().toList();
    if (remainingPieces.isEmpty) return;
    final anyFits = remainingPieces.any(pieceFitsAnywhere);
    if (!anyFits) gameOver();
  }

  Future<void> gameOver() async {
    await sessionFlow.showGameOver(
      result: GameResult(score: score.value, comboStreak: comboStreak.value),
      reviveAvailable: !reviveUsed,
      onRevive: () async => revive(),
      onRetry: () async => restart(),
      onHome: () async => Get.offAllNamed(AppRoutes.home),
    );
  }

  void revive() {
    reviveUsed = true;
    final rowFillCounts = <int, int>{
      for (var row = 0; row < gridSize; row++)
        row: List.generate(gridSize, (col) => cells[row * gridSize + col]).where((value) => value != 0).length,
    };
    final rowsBySize = rowFillCounts.keys.toList()..sort((a, b) => rowFillCounts[b]!.compareTo(rowFillCounts[a]!));
    for (final row in rowsBySize.take(2)) {
      for (var col = 0; col < gridSize; col++) {
        cells[row * gridSize + col] = 0;
      }
    }
    checkGameOver();
  }

  void restart() {
    cells.assignAll(List<int>.filled(cellCount, 0));
    tray.assignAll(List<BlockoPiece?>.filled(3, null));
    score.value = 0;
    comboStreak.value = 0;
    reviveUsed = false;
    best.value = sessionFlow.bestScore;
    fillTrayIfEmpty();
  }
}
