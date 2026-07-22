import 'package:hive_flutter/hive_flutter.dart';

/// Opens the local Hive boxes used across every game. No login, no server —
/// everything lives on-device (GAME_IDEAS.md §3.4).
class HiveService {
  static const String settingsBox = 'settings';
  static const String progressBox = 'progress';
  static const String adMetaBox = 'admeta';
  static const String economyBox = 'economy';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(settingsBox),
      Hive.openBox(progressBox),
      Hive.openBox(adMetaBox),
      Hive.openBox(economyBox),
    ]);
  }
}
