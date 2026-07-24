import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

import '../../../game/data/model/blockoColors.dart';

/// A decorative static preview of the falling-block well shown on Home:
/// a settled stack near the bottom plus one piece near the top
/// (GAME_IDEAS.md §4.0 "Distinctive Home").
class BoardPreviewWidget extends StatelessWidget {
  const BoardPreviewWidget({super.key});

  static const int columns = 6;

  static const List<int> pattern = [
    0, 0, 3, 3, 0, 0, //
    0, 0, 0, 3, 0, 0, //
    0, 0, 0, 0, 0, 0, //
    0, 0, 0, 0, 0, 0, //
    0, 1, 1, 1, 1, 0, //
    2, 2, 5, 4, 4, 0, //
    2, 2, 5, 5, 4, 4, //
    1, 1, 3, 5, 5, 4, //
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.gapMedium),
      decoration: stickerDecoration(fill: surfaceTone(const Color(0xFFF5E4BE)), radius: AppSizes.radiusPanel, border: BorderWidths.thick, drop: 6),
      child: AspectRatio(
        aspectRatio: 0.7,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisSpacing: 3, crossAxisSpacing: 3),
          itemCount: pattern.length,
          itemBuilder: (context, index) {
            final colorIndex = pattern[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                color: colorIndex == 0 ? Colors.white.withOpacity(0.15) : BlockoColors.palette[colorIndex - 1],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
              ),
            );
          },
        ),
      ),
    );
  }
}
