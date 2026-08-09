import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';
import 'blockoNeonToggle.dart';

/// One neon settings row: icon + label + toggle — the "Neon Drop"
/// equivalent of the shared cutesy `SettingsToggleRow`.
class BlockoSettingsToggleRow extends StatelessWidget {
  const BlockoSettingsToggleRow({
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
    final palette = BlockoNeonTokens.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: palette.panelBackground,
        border: Border.all(color: palette.panelBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: palette.panelBorder),
            ),
            child: SvgPicture.asset(
              iconAsset,
              package: 'game_core',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(palette.textPrimary, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: BlockoNeonText.menuItem(color: palette.textPrimary))),
          BlockoNeonToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
