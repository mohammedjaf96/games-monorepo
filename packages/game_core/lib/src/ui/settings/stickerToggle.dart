import 'package:flutter/material.dart';

import '../../theme/borderWidths.dart';
import '../../theme/outlineColor.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';

/// A 54x28 sticker-style toggle switch: green ON, gray OFF, a white knob
/// with a dark border (GAME_IDEAS.md §3.16.3).
class StickerToggle extends StatelessWidget {
  const StickerToggle({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 54,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: stickerDecoration(
          fill: value ? Pal.green : Pal.rarityCommon,
          radius: 14,
          border: BorderWidths.thin,
          drop: 3,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeOut,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: OutlineColor.color, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
