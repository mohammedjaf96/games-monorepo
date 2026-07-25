import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Blocko's "Neon Drop" type scale — Orbitron for the wordmark, score, and
/// overlay titles; Rubik for menu/body copy. Distinct from the shared
/// `AppText` (Baloo 2) used by Dashy/Mergo — Blocko alone carries this look.
class BlockoNeonText {
  static TextStyle title({required Color color}) => GoogleFonts.orbitron(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: color,
        fontStyle: FontStyle.italic,
      );

  static TextStyle score({required Color color}) =>
      GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.w700, color: color);

  static TextStyle overlayTitle({required Color color, double size = 28}) =>
      GoogleFonts.orbitron(fontSize: size, fontWeight: FontWeight.w800, letterSpacing: 3, color: color);

  static TextStyle overlayButton({required Color color}) =>
      GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1, color: color);

  static TextStyle menuItem({required Color color}) =>
      GoogleFonts.rubik(fontSize: 15, fontWeight: FontWeight.w500, color: color);

  static TextStyle body({required Color color}) => GoogleFonts.rubik(fontSize: 14, fontWeight: FontWeight.w400, color: color);
}
