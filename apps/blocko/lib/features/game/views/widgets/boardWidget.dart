import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import '../../data/model/blockoColors.dart';

/// The 8x8 board: a grid of drag targets that accept pieces from the tray
/// (GAME_IDEAS.md §4.2/§4.4).
class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapSmall),
      decoration: stickerDecoration(
        fill: const Color(0xFFF5E4BE),
        radius: AppSizes.radiusPanel,
        border: BorderWidths.thick,
        drop: 6,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: cellCount,
          itemBuilder: (context, index) {
            final row = index ~/ gridSize;
            final col = index % gridSize;
            return DragTarget<int>(
              onWillAcceptWithDetails: (details) {
                final piece = controller.tray[details.data];
                if (piece == null) return false;
                controller.updatePreview(piece, row, col);
                return true;
              },
              onLeave: (data) => controller.clearPreview(),
              onAcceptWithDetails: (details) => controller.tryPlacePiece(details.data, row, col),
              builder: (context, candidateData, rejectedData) {
                return Obx(() {
                  final value = controller.cells[index];
                  final isPreview = controller.previewCells.contains(index);
                  final fillColor = value != 0
                      ? BlockoColors.palette[value - 1]
                      : isPreview
                          ? (controller.previewValid.value ? Pal.green : Pal.red).withOpacity(0.4)
                          : Colors.white;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
                    ),
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}
