import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Unified analytics logging (GAME_IDEAS.md §3.7/§9). No Firebase wiring yet,
/// so every event is logged via [debugPrint] — swap in a real provider later
/// without touching call sites.
class AnalyticsService extends GetxService {
  AnalyticsService init() => this;

  void log(String event, [Map<String, dynamic> params = const {}]) {
    debugPrint('analytics: $event $params');
  }
}
