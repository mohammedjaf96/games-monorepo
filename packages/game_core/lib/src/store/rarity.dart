import 'package:flutter/widgets.dart';

import '../theme/pal.dart';

/// Cosmetic rarity tiers, each with its own frame color (GAME_IDEAS.md §3.14.5).
enum Rarity { common, rare, epic, legendary }

extension RarityColor on Rarity {
  Color get color => switch (this) {
        Rarity.common => Pal.rarityCommon,
        Rarity.rare => Pal.rarityRare,
        Rarity.epic => Pal.rarityEpic,
        Rarity.legendary => Pal.rarityLegendary,
      };
}
