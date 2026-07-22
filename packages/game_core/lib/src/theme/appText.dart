import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified type scale (GAME_IDEAS.md §3.15). Font: Baloo 2, weight 800 for
/// headings/buttons/numbers.
class AppText {
  static TextStyle heroNumber({Color color = const Color(0xFF141428)}) =>
      GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w800, color: color);

  static TextStyle title({Color color = const Color(0xFF141428)}) =>
      GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.w700, color: color);

  static TextStyle buttonLabel({Color color = const Color(0xFF141428)}) =>
      GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 1,
      );

  static TextStyle body({Color color = const Color(0xFF141428)}) =>
      GoogleFonts.baloo2(fontSize: 14, fontWeight: FontWeight.w500, color: color);

  static TextStyle label({Color color = const Color(0xFF141428)}) =>
      GoogleFonts.baloo2(fontSize: 12, fontWeight: FontWeight.w700, color: color);

  static TextStyle caption({Color color = const Color(0xFF141428)}) =>
      GoogleFonts.baloo2(fontSize: 11, fontWeight: FontWeight.w600, color: color);
}
