import 'package:flutter/widgets.dart';

/// A single game's color identity, derived from [Pal] (GAME_IDEAS.md §3.14.8).
class GamePalette {
  const GamePalette({
    required this.primary,
    required this.secondary,
    required this.accents,
    required this.background,
    required this.backgroundEnd,
    required this.panel,
    required this.surface,
    required this.primaryCta,
    required this.splashStart,
    required this.splashEnd,
  });

  final Color primary;
  final Color secondary;
  final List<Color> accents;
  final Color background;
  final Color backgroundEnd;
  final Color panel;
  final Color surface;
  final Color primaryCta;
  final Color splashStart;
  final Color splashEnd;
}
