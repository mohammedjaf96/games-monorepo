import 'package:flutter/widgets.dart';

/// The abstract, skinnable premium currency (GAME_IDEAS.md §3.11.2). The gem
/// shape/color is unified across all games — `game_core` only renders
/// [assetIcon], never a hardcoded shape.
class CurrencySkin {
  const CurrencySkin({
    required this.id,
    required this.nameKey,
    required this.assetIcon,
    required this.color,
    required this.glowColor,
  });

  final String id;
  final String nameKey;
  final String assetIcon;
  final Color color;
  final Color glowColor;
}
