import 'cosmeticSlot.dart';

/// A tab in the store screen (GAME_IDEAS.md §3.11.7-b), e.g. Characters, Backgrounds.
class StoreCategory {
  const StoreCategory({required this.id, required this.nameKey, required this.slot});

  final String id;
  final String nameKey;
  final CosmeticSlot slot;
}
