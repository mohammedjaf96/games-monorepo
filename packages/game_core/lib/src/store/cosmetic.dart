import 'cosmeticSlot.dart';
import 'rarity.dart';

/// A single purchasable/unlockable item in a game's store (GAME_IDEAS.md §3.11.5).
class Cosmetic {
  const Cosmetic({
    required this.id,
    required this.slot,
    required this.nameKey,
    required this.rarity,
    required this.previewAsset,
    this.priceGems = 0,
    this.unlockableByAd = false,
    this.defaultOwned = false,
  });

  final String id;
  final CosmeticSlot slot;
  final String nameKey;
  final int priceGems;
  final bool unlockableByAd;
  final Rarity rarity;
  final String previewAsset;
  final bool defaultOwned;
}
