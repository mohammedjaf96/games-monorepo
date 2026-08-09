import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'outlineColor.dart';

/// Unified type scale (GAME_IDEAS.md §3.15). Font: Baloo 2, weight 800 for
/// headings/buttons/numbers. `color` defaults to the current theme's ink
/// color (dark in light mode, light in dark mode) when omitted.
class AppText {
  static TextStyle heroNumber({Color? color}) =>
      GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w800, color: color ?? OutlineColor.color);

  static TextStyle title({Color? color}) =>
      GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.w700, color: color ?? OutlineColor.color);

  static TextStyle buttonLabel({Color? color}) => GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: color ?? OutlineColor.color,
        letterSpacing: 1,
      );

  static TextStyle body({Color? color}) =>
      GoogleFonts.baloo2(fontSize: 14, fontWeight: FontWeight.w500, color: color ?? OutlineColor.color);

  static TextStyle label({Color? color}) =>
      GoogleFonts.baloo2(fontSize: 12, fontWeight: FontWeight.w700, color: color ?? OutlineColor.color);

  static TextStyle caption({Color? color}) =>
      GoogleFonts.baloo2(fontSize: 11, fontWeight: FontWeight.w600, color: color ?? OutlineColor.color);
}
