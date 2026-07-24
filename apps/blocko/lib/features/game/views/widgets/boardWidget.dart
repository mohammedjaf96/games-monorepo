import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import '../../data/model/blockoColors.dart';
import '../../data/model/blockoShapes.dart';

/// The 10x20 falling-block well: settled cells plus the currently falling
/// piece, both animated smoothly between positions (GAME_IDEAS.md §4.2/§4.4).
class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

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
                              key: ValueKey(
                                controller.clearingRows.contains(index ~/ gridWidth)
                                    ? 'clearing-$index'
                                    : controller.cells[index] != 0
                                        ? 'filled-$index-${controller.cells[index]}'
                                        : 'empty-$index',
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: controller.clearingRows.contains(index ~/ gridWidth)
                                      ? Colors.white
                                      : controller.cells[index] != 0
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
