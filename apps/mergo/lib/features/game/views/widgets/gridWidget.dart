import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';
import '../../data/model/swipeDirection.dart';
import 'tileWidget.dart';

/// The 4x4 grid: swipe to slide/merge tiles, tap a tile while the hammer is
/// active to remove it (GAME_IDEAS.md §6.2/§6.4).
class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapSmall),
      decoration: stickerDecoration(
        fill: Pal.cream,
        radius: AppSizes.radiusPanel,
        border: BorderWidths.thick,
        drop: 6,
      ),
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity.abs() < 50) return;
          controller.swipe(velocity > 0 ? SwipeDirection.down : SwipeDirection.up);
        },
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity.abs() < 50) return;
          controller.swipe(velocity > 0 ? SwipeDirection.right : SwipeDirection.left);
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridDimension,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: cellCount,
            itemBuilder: (context, index) {
              return Obx(() {
                final value = controller.cells[index];
                return GestureDetector(
                  onTap: () => controller.onTileTap(index),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: TileWidget(key: ValueKey('$index-$value'), value: value),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
