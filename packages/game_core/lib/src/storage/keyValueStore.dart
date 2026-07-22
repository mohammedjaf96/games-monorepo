import 'package:hive_flutter/hive_flutter.dart';

/// Thin, typed read/write helper over Hive boxes opened by [HiveService].
class KeyValueStore {
  static T get<T>(String box, String key, T fallback) {
    final openBox = Hive.box(box);
    return (openBox.get(key) as T?) ?? fallback;
  }

  static Future<void> set(String box, String key, dynamic value) async {
    final openBox = Hive.box(box);
    await openBox.put(key, value);
  }
}
