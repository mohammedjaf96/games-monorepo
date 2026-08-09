import 'package:flutter/widgets.dart';

/// One particle-burst event: a handful of colored dots flying outward from
/// a point and fading (GAME_IDEAS.md §3.8-c). `id` must be unique per burst
/// so the overlay can track and remove it after its animation finishes.
class ParticleBurst {
  const ParticleBurst({required this.id, required this.color});

  final int id;
  final Color color;
}
