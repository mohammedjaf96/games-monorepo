import 'package:flutter/material.dart';

import '../theme/pal.dart';
import 'bouncyButton.dart';

/// A rewarded-ad CTA: a video icon + label (GAME_IDEAS.md §3.9), e.g.
/// "Continue" or "Double coins".
class RewardedButton extends StatelessWidget {
  const RewardedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fill = Pal.purple,
  });

  final String label;
  final Future<void> Function()? onPressed;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      label: label,
      fill: fill,
      textColor: Colors.white,
      icon: const Icon(Icons.smart_display_rounded, color: Colors.white, size: 18),
      onPressed: onPressed == null ? null : () => onPressed!(),
    );
  }
}
