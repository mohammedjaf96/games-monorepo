import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Best-effort browser vibration for when the game is played through a
/// plain web link instead of an installed app — Flutter's own
/// `HapticFeedback` has no web implementation at all. Android Chrome
/// supports this; iOS Safari has never implemented the Vibration API, so
/// this silently does nothing there.
void triggerWebVibration(int milliseconds) {
  try {
    web.window.navigator.vibrate(milliseconds.toJS);
  } catch (_) {
    // Vibration API unsupported on this browser — no-op.
  }
}
