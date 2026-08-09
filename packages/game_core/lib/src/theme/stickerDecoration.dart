import 'package:flutter/widgets.dart';

import 'borderWidths.dart';
import 'outlineColor.dart';

/// The base sticker-style recipe: a thick dark border + a solid, unblurred
/// drop shadow (GAME_IDEAS.md §3.14.0). `blurRadius` is always 0 — any blur
/// destroys the cartoon-sticker feel. `outline` defaults to the current
/// theme's ink color (dark in light mode, light in dark mode) when omitted.
BoxDecoration stickerDecoration({
  required Color fill,
  double radius = 14,
  double border = BorderWidths.thick,
  double drop = 5,
  Color? outline,
}) {
  final resolvedOutline = outline ?? OutlineColor.color;
  return BoxDecoration(
    color: fill,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: resolvedOutline, width: border),
    boxShadow: [BoxShadow(color: resolvedOutline, offset: Offset(0, drop), blurRadius: 0)],
  );
}
