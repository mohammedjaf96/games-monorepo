import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import '../../data/model/blockoColors.dart';
import '../../data/model/blockoShapes.dart';

/// The 10x20 falling-block well: settled cells plus the currently falling
/// piece, both animated smoothly between positions (GAME_IDEAS.md §4.2/§4.4).
class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  static const int shatterParticlesPerCell = 3;
  static const double shatterTravel = 16;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapSmall),
      decoration: stickerDecoration(fill: const Color(0xFFF5E4BE), radius: AppSizes.radiusPanel, border: BorderWidths.thick, drop: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = min(constraints.maxWidth / gridWidth, constraints.maxHeight / gridHeight);
          return Center(
            child: SizedBox(
              width: cellSize * gridWidth,
              height: cellSize * gridHeight,
              child: Obx(() {
                final fallingType = controller.fallingType.value;
                final fallingCells = fallingType == null ? const <Point<int>>[] : BlockoShapes.cellsFor(fallingType, controller.fallingRotation.value);
                return Stack(
                  children: [
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
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: BlockoColors.palette[controller.cells[index] - 1],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
                              ),
                            )
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
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: controller.cells[index] != 0
                                        ? BlockoColors.palette[controller.cells[index] - 1]
                                        : Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
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
                                left: centerX - 2,
                                top: centerY - 2,
                                width: 4,
                                height: 4,
                                child: DecoratedBox(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1)))
                                    .animate()
                                    .moveXY(begin: Offset.zero, end: Offset(cos(angle) * distance, sin(angle) * distance), duration: GameController.shatterDurationMs.ms, curve: Curves.easeOut)
                                    .fadeOut(duration: GameController.shatterDurationMs.ms),
                              );
                            },
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
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: BlockoColors.colorFor(fallingType!),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
