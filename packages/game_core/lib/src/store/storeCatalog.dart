import 'cosmetic.dart';
import 'storeCategory.dart';

/// The full store content supplied by each app (GAME_IDEAS.md §3.11.5).
class StoreCatalog {
  const StoreCatalog({required this.categories, required this.cosmetics});

  final List<StoreCategory> categories;
  final List<Cosmetic> cosmetics;
}
