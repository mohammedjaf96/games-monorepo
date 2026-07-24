import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import '../../data/model/blockoColors.dart';
import '../../data/model/blockoLandingFlash.dart';
import '../../data/model/blockoShapes.dart';
import '../../data/model/blockoShiftingCell.dart';

/// The falling-block well: settled cells plus the currently falling piece,
/// both animated smoothly between positions. 20 nutfa wide; the row count
/// is computed from the actual screen space on first layout, so the board
/// always fills the device's height instead of assuming a fixed shape.
class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  static const int shatterParticlesPerCell = 7;
  static const double shatterTravel = 18;
  static const double nutfaRadius = 2;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final bevelDecoration = (Color color) => BoxDecoration(
          borderRadius: BorderRadius.circular(nutfaRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(color, Colors.white, 0.35)!, color, Color.lerp(color, Colors.black, 0.22)!],
            stops: const [0, 0.5, 1],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(AppSizes.gapSmall),
      decoration: stickerDecoration(fill: surfaceTone(const Color(0xFFEFF0FA)), radius: AppSizes.radiusPanel, border: BorderWidths.thick, drop: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSizeForWidth = constraints.maxWidth / gridWidth;
          final computedRows = (constraints.maxHeight / cellSizeForWidth).floor();
          WidgetsBinding.instance.addPostFrameCallback((_) => controller.configureBoardHeight(computedRows));

          return Center(
            child: Obx(() {
              final cellSize = min(cellSizeForWidth, constraints.maxHeight / gridHeight);
              final fallingType = controller.fallingType.value;
              final fallingCells = fallingType == null ? const <Point<int>>[] : BlockoShapes.cellsFor(fallingType, controller.fallingRotation.value);
              return SizedBox(
                width: cellSize * gridWidth,
                height: cellSize * gridHeight,
                child: Stack(
                  children: [
                    for (final flash in controller.landingFlashes)
                      for (final index in flash.cellIndexes)
                        if (controller.cells[index] != 0)
                          Positioned(
                            key: ValueKey('landFlash-${flash.id}-$index'),
                            left: (index % gridWidth) * cellSize - 1,
                            top: (index ~/ gridWidth) * cellSize - 1,
                            width: cellSize + 2,
                            height: cellSize + 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(nutfaRadius + 1),
                                border: Border.all(color: Color.lerp(BlockoColors.palette[controller.cells[index] - 1], Colors.white, 0.3)!, width: 1.4),
                                boxShadow: [
                                  BoxShadow(color: BlockoColors.palette[controller.cells[index] - 1].withOpacity(0.95), blurRadius: 5, spreadRadius: 0.5),
                                  BoxShadow(color: BlockoColors.palette[controller.cells[index] - 1].withOpacity(0.5), blurRadius: 12, spreadRadius: 1),
                                ],
                              ),
                            ).animate().fadeOut(duration: 260.ms),
                          ),
                    for (var index = 0; index < cellCount; index++)
                      if (controller.clearingRows.contains(index ~/ gridWidth) && controller.cells[index] != 0)
                        Positioned(
                          key: ValueKey('shatterCore-${controller.clearEventId.value}-$index'),
                          left: (index % gridWidth) * cellSize,
                          top: (index ~/ gridWidth) * cellSize,
                          width: cellSize,
                          height: cellSize,
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: DecoratedBox(decoration: bevelDecoration(BlockoColors.palette[controller.cells[index] - 1]))
                                .animate()
                                .fadeOut(duration: Duration(milliseconds: (GameController.shatterDurationMs * 0.7).round()))
                                .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(0.4, 0.4),
                                  duration: Duration(milliseconds: (GameController.shatterDurationMs * 0.7).round()),
                                ),
                          ),
                        )
                      else
                        Positioned(
                          left: (index % gridWidth) * cellSize,
                          top: (index ~/ gridWidth) * cellSize,
                          width: cellSize,
                          height: cellSize,
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                              child: KeyedSubtree(
                                key: ValueKey(controller.cells[index] != 0 ? 'filled-$index-${controller.cells[index]}' : 'empty-$index'),
                                child: controller.cells[index] != 0
                                    ? DecoratedBox(decoration: bevelDecoration(BlockoColors.palette[controller.cells[index] - 1]))
                                    : DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(nutfaRadius),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                    for (var index = 0; index < cellCount; index++)
                      if (controller.clearingRows.contains(index ~/ gridWidth) && controller.cells[index] != 0)
                        for (var p = 0; p < shatterParticlesPerCell; p++)
                          Builder(
                            key: ValueKey('shatter-${controller.clearEventId.value}-$index-$p'),
                            builder: (context) {
                              final rand = Random(index * 37 + p * 11 + controller.clearEventId.value);
                              final angle = rand.nextDouble() * 2 * pi;
                              final distance = shatterTravel * 0.6 + rand.nextDouble() * shatterTravel;
                              final centerX = (index % gridWidth) * cellSize + cellSize / 2;
                              final centerY = (index ~/ gridWidth) * cellSize + cellSize / 2;
                              final color = BlockoColors.palette[controller.cells[index] - 1];
                              return Positioned(
                                left: centerX - 1.5,
                                top: centerY - 1.5,
                                width: 3,
                                height: 3,
                                child: DecoratedBox(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1)))
                                    .animate()
                                    .moveXY(begin: Offset.zero, end: Offset(cos(angle) * distance, sin(angle) * distance), duration: GameController.shatterDurationMs.ms, curve: Curves.easeOut)
                                    .fadeOut(duration: Duration(milliseconds: (GameController.shatterDurationMs * 0.55).round())),
                              );
                            },
                          ),
                    for (final shift in controller.shiftingCells)
                      AnimatedPositioned(
                        key: ValueKey('shift-${controller.shiftEventId.value}-${shift.fromIndex}'),
                        duration: const Duration(milliseconds: GameController.shiftDurationMs),
                        curve: Curves.easeIn,
                        left: ((controller.shiftSettled.value ? shift.toIndex : shift.fromIndex) % gridWidth) * cellSize,
                        top: ((controller.shiftSettled.value ? shift.toIndex : shift.fromIndex) ~/ gridWidth) * cellSize,
                        width: cellSize,
                        height: cellSize,
                        child: Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: DecoratedBox(decoration: bevelDecoration(BlockoColors.palette[shift.colorValue - 1])),
                        ),
                      ),
                    for (var i = 0; i < fallingCells.length; i++)
                      AnimatedPositioned(
                        key: ValueKey('fallingCell${controller.fallingSpawnId.value}-$i'),
                        duration: const Duration(milliseconds: 130),
                        curve: Curves.easeOut,
                        left: (controller.fallingCol.value + fallingCells[i].y) * cellSize,
                        top: (controller.fallingRow.value + fallingCells[i].x) * cellSize,
                        width: cellSize,
                        height: cellSize,
                        child: Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: DecoratedBox(decoration: bevelDecoration(BlockoColors.colorFor(fallingType!))),
                        ),
                      ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
