import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../analytics/analyticsService.dart';
import '../audio/audioService.dart';
import '../audio/hapticPattern.dart';
import '../audio/hapticsService.dart';
import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';
import 'cosmeticSlot.dart';
import 'storeCatalog.dart';

/// Tracks which cosmetics are owned and which one is currently selected per
/// slot (GAME_IDEAS.md §3.11.5). Persists to the `economy` Hive box.
class InventoryService extends GetxService {
  InventoryService(this.catalog);

  final StoreCatalog catalog;
  final RxSet<String> owned = <String>{}.obs;
  final RxMap<CosmeticSlot, String> selected = <CosmeticSlot, String>{}.obs;

  final AnalyticsService analytics = Get.find<AnalyticsService>();
  final AudioService audio = Get.find<AudioService>();
  final HapticsService haptics = Get.find<HapticsService>();

  Future<InventoryService> init() async {
    final storedOwned = KeyValueStore.get<List>(HiveService.economyBox, 'owned', const []);
    owned.addAll(storedOwned.map((item) => item.toString()));
    for (final cosmetic in catalog.cosmetics) {
      if (cosmetic.defaultOwned) owned.add(cosmetic.id);
    }

    final storedSelected = KeyValueStore.get<Map>(HiveService.economyBox, 'selectedBySlot', const {});
    storedSelected.forEach((key, value) {
      final slot = CosmeticSlot.values.firstWhereOrNull((s) => s.name == key);
      if (slot != null) selected[slot] = value.toString();
    });
    for (final cosmetic in catalog.cosmetics) {
      if (cosmetic.defaultOwned && !selected.containsKey(cosmetic.slot)) {
        selected[cosmetic.slot] = cosmetic.id;
      }
    }
    return this;
  }

  bool isOwned(String id) => owned.contains(id);

  Future<void> unlock(String id) async {
    if (owned.contains(id)) return;
    owned.add(id);
    await KeyValueStore.set(HiveService.economyBox, 'owned', owned.toList());
    await audio.playSfx('unlock');
    await haptics.pulse(HapticPattern.heavy);
    final cosmetic = catalog.cosmetics.firstWhereOrNull((c) => c.id == id);
    analytics.log('cosmetic_unlocked', {
      'id': id,
      'via': cosmetic != null && cosmetic.priceGems > 0 ? 'gems' : 'ad',
      'rarity': cosmetic?.rarity.name,
    });
  }

  Future<void> select(CosmeticSlot slot, String id) async {
    selected[slot] = id;
    final map = selected.map((key, value) => MapEntry(key.name, value));
    await KeyValueStore.set(HiveService.economyBox, 'selectedBySlot', map);
    analytics.log('cosmetic_selected', {'id': id, 'slot': slot.name});
  }

  String? selectedId(CosmeticSlot slot) => selected[slot];
}
