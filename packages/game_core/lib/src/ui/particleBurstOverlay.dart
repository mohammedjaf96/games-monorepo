import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'particleBurst.dart';

/// Renders each active [ParticleBurst] as 8 dots flying outward from the
/// overlay's center and fading (GAME_IDEAS.md §3.8-c). The caller owns the
/// burst list's lifecycle (add on clear/merge, remove after ~500ms).
class ParticleBurstOverlay extends StatelessWidget {
  const ParticleBurstOverlay({super.key, required this.bursts});

  final List<ParticleBurst> bursts;

  static const int dotsPerBurst = 8;
  static const double travelDistance = 42;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final burst in bursts)
            for (var i = 0; i < dotsPerBurst; i++)
              Builder(
                key: ValueKey('${burst.id}_$i'),
                builder: (context) {
                  final angle = (i / dotsPerBurst) * 2 * pi;
                  final dx = cos(angle) * travelDistance;
                  final dy = sin(angle) * travelDistance;
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: burst.color, shape: BoxShape.circle),
                  )
                      .animate()
                      .moveXY(begin: Offset.zero, end: Offset(dx, dy), duration: 450.ms, curve: Curves.easeOut)
                      .fadeOut(duration: 450.ms)
                      .scale(begin: const Offset(1, 1), end: const Offset(0.3, 0.3), duration: 450.ms);
                },
              ),
        ],
      ),
    );
  }
}
