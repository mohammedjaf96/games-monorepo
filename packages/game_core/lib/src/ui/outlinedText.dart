import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/outlineColor.dart';
import '../theme/pal.dart';

/// Puffy logo/heading text: a thick black outline around the letters plus a
/// solid colored shadow beneath them (GAME_IDEAS.md §3.14.0).
class OutlinedText extends StatelessWidget {
  const OutlinedText(
    this.text, {
    super.key,
    this.size = 30,
    required this.fill,
    this.shadow = Pal.orange,
    this.strokeWidth = 7,
  });

  final String text;
  final double size;
  final Color fill;
  final Color shadow;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.baloo2(fontSize: size, fontWeight: FontWeight.w800);
    return Stack(
      children: [
        Text(
          text,
          style: baseStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = OutlineColor.color
              ..strokeJoin = StrokeJoin.round,
          ),
        ),
        Text(
          text,
          style: baseStyle.copyWith(
            color: fill,
            shadows: [Shadow(color: shadow, offset: const Offset(0, 5), blurRadius: 0)],
          ),
        ),
      ],
    );
  }
}
