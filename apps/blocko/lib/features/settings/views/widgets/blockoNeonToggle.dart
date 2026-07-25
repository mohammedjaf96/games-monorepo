import 'package:flutter/material.dart';

import '../../../../core/theme/blockoNeonTokens.dart';

/// A neon-styled toggle switch — the "Neon Drop" equivalent of the shared
/// cutesy `StickerToggle`.
class BlockoNeonToggle extends StatelessWidget {
  const BlockoNeonToggle({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = BlockoNeonTokens.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 54,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? palette.scoreColor.withOpacity(0.25) : Colors.transparent,
          border: Border.all(color: value ? palette.scoreColor : palette.panelBorder),
          boxShadow: value ? [BoxShadow(color: palette.scoreGlow, blurRadius: 8)] : const [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeOut,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: value ? palette.scoreColor : palette.textSecondary, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
