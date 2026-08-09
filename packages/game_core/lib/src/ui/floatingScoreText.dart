import 'package:flutter/widgets.dart';

import '../theme/pal.dart';

/// One floating "+120" / "Combo x3!" text event (GAME_IDEAS.md §3.8-c:
/// "floats up and fades"). `id` must be unique so the overlay can track and
/// remove it once its animation finishes.
class FloatingScoreText {
  const FloatingScoreText({required this.id, required this.text, this.color = Pal.orange});

  final int id;
  final String text;
  final Color color;
}
