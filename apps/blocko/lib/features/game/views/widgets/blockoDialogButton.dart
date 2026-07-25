import 'package:flutter/material.dart';

import '../../../../core/theme/blockoNeonText.dart';

/// A neon-styled button for Blocko's popups (filled/glowing for the primary
/// action, outlined for secondary ones) — the "Neon Drop" equivalent of the
/// cutesy `BouncyButton`/`RewardedButton` used by the other games.
class BlockoDialogButton extends StatelessWidget {
  const BlockoDialogButton({
    super.key,
    required this.label,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: filled ? [BoxShadow(color: color.withOpacity(0.55), blurRadius: 16, spreadRadius: 1)] : const [],
      ),
      child: SizedBox(
        width: double.infinity,
        child: filled
            ? ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(label.toUpperCase(), style: BlockoNeonText.overlayButton(color: const Color(0xFF0A0713))),
              )
            : OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(label.toUpperCase(), style: BlockoNeonText.overlayButton(color: color)),
              ),
      ),
    );
  }
}
