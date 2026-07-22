import 'package:flutter/widgets.dart';

import 'borderWidths.dart';
import 'outlineColor.dart';

/// The base sticker-style recipe: a thick dark border + a solid, unblurred
/// drop shadow (GAME_IDEAS.md §3.14.0). `blurRadius` is always 0 — any blur
/// destroys the cartoon-sticker feel.
BoxDecoration stickerDecoration({
  required Color fill,
  double radius = 14,
  double border = BorderWidths.thick,
  double drop = 5,
  Color outline = OutlineColor.color,
}) {
  return BoxDecoration(
    color: fill,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: outline, width: border),
    boxShadow: [BoxShadow(color: outline, offset: Offset(0, drop), blurRadius: 0)],
  );
}
