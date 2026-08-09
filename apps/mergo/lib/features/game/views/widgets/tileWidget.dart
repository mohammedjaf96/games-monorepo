import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

import '../../data/model/mergoTileColors.dart';

/// A single numbered tile, colored by its value (GAME_IDEAS.md §6.8).
class TileWidget extends StatelessWidget {
  const TileWidget({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceTone(Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: OutlineColor.color, width: BorderWidths.hairline),
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      decoration: stickerDecoration(
        fill: MergoTileColors.colorFor(value),
        radius: 10,
        border: BorderWidths.thin,
        drop: 3,
      ),
      child: Text(
        '$value',
        style: AppText.title(color: value <= 4 ? OutlineColor.color : Colors.white),
      ),
    );
  }
}
