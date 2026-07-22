import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import 'pieceShapeWidget.dart';

/// The 3-piece tray beneath the board (GAME_IDEAS.md §4.2/§4.3).
class PieceTrayWidget extends StatelessWidget {
  const PieceTrayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(controller.tray.length, (index) {
          final piece = controller.tray[index];
          if (piece == null) return const SizedBox(width: 60, height: 60);
          return Draggable<int>(
            data: index,
            feedback: Material(
              color: Colors.transparent,
              child: PieceShapeWidget(piece: piece, cellSize: 28),
            ),
            childWhenDragging: Opacity(opacity: 0.3, child: PieceShapeWidget(piece: piece)),
            child: PieceShapeWidget(piece: piece),
          );
        }),
      ),
    );
  }
}
