import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/appSizes.dart';
import '../../theme/appText.dart';
import '../../theme/borderWidths.dart';
import '../../theme/pal.dart';
import '../../theme/stickerDecoration.dart';
import '../../theme/surfaceTone.dart';
import 'stickerToggle.dart';

/// One settings row: icon container + label + toggle (GAME_IDEAS.md §3.16.3).
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String iconAsset;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.gapMedium),
      padding: const EdgeInsets.all(AppSizes.gapMedium),
      decoration: stickerDecoration(
        fill: surfaceTone(Colors.white),
        radius: AppSizes.radiusCard,
        border: BorderWidths.thin,
        drop: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: stickerDecoration(
              fill: Pal.blue,
              radius: 10,
              border: BorderWidths.thin,
              drop: 3,
            ),
            child: SvgPicture.asset(iconAsset, package: 'game_core', width: 18, height: 18),
          ),
          const SizedBox(width: AppSizes.gapMedium),
          Expanded(child: Text(label, style: AppText.body())),
          StickerToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
