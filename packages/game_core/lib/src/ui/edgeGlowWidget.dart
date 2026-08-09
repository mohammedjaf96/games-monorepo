import 'package:flutter/material.dart';

import 'edgeGlowPainter.dart';

/// Wraps [child] with a full-bounds glow that pulses around just the very
/// edges of the screen — the "Siri / Apple Intelligence ring" idea,
/// recolored to the game's own brand colors. Increment [trigger] to replay
/// it; set [big] for a stronger pulse on a bigger moment (e.g. clearing
/// multiple rows at once).
class EdgeGlowWidget extends StatelessWidget {
  const EdgeGlowWidget({
    super.key,
    required this.trigger,
    required this.child,
    required this.hotColor,
    required this.primaryColor,
    required this.deepColor,
    this.big = false,
    this.duration = const Duration(milliseconds: 1300),
  });

  final int trigger;
  final Widget child;
  final Color hotColor;
  final Color primaryColor;
  final Color deepColor;
  final bool big;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: TweenAnimationBuilder<double>(
              key: ValueKey(trigger),
              tween: Tween(begin: 0.0, end: trigger == 0 ? 0.0 : 1.0),
              duration: duration,
              builder: (context, t, painterChild) {
                final intensity = t < 0.14
                    ? t / 0.14
                    : t < 0.55
                        ? 1.0
                        : (1 - (t - 0.55) / 0.45).clamp(0.0, 1.0);
                return CustomPaint(
                  painter: EdgeGlowPainter(intensity: intensity, big: big, hotColor: hotColor, primaryColor: primaryColor, deepColor: deepColor),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
