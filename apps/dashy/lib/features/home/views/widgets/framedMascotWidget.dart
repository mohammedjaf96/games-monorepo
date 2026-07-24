import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

/// The mascot inside a circular yellow frame with a dark outline and solid
/// shadow — Dashy's "Clash-style HUD" hero treatment (GAME_IDEAS.md §5.0).
class FramedMascotWidget extends StatelessWidget {
  const FramedMascotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Pal.yellow,
        shape: BoxShape.circle,
        border: Border.all(color: OutlineColor.color, width: BorderWidths.thick),
        boxShadow: [BoxShadow(color: OutlineColor.color, offset: const Offset(0, 6), blurRadius: 0)],
      ),
      child: const MascotWidget(game: 'dashy', size: 110),
    );
  }
}
