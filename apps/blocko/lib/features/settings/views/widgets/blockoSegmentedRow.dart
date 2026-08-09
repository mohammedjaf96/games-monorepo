import 'package:flutter/material.dart';

import '../../../../core/theme/blockoNeonText.dart';
import '../../../../core/theme/blockoNeonTokens.dart';

/// A label plus a row of selectable neon chips — used for both the
/// language picker (EN/AR) and the theme-mode picker (System/Light/Dark)
/// on Blocko's Settings screen.
class BlockoSegmentedRow extends StatelessWidget {
  const BlockoSegmentedRow({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  final String label;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: palette.panelBackground,
        border: Border.all(color: palette.panelBorder),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: BlockoNeonText.menuItem(color: palette.textPrimary))),
          for (var index = 0; index < options.length; index++)
            Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
              child: GestureDetector(
                onTap: () => onSelect(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selectedIndex == index ? palette.scoreColor : Colors.transparent,
                    border: Border.all(color: selectedIndex == index ? palette.scoreColor : palette.panelBorder),
                  ),
                  child: Text(
                    options[index],
                    style: BlockoNeonText.overlayButton(
                      color: selectedIndex == index ? const Color(0xFF0A0713) : palette.textSecondary,
                    ).copyWith(fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
