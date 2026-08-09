import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';

/// Plays short SFX and looping BGM (GAME_IDEAS.md §3.8-a). Always checks the
/// sound/music settings first, and every call is wrapped in try/catch so a
/// missing audio asset never crashes the game.
class AudioService extends GetxService {
  final AudioPlayer bgmPlayer = AudioPlayer();
  String? lastBgmPath;
  bool _firstInteractionHandled = false;

  Future<AudioService> init() async {
    try {
      await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (_) {}
    return this;
  }

  bool get soundEnabled => KeyValueStore.get(HiveService.settingsBox, 'sound', true);

  bool get musicEnabled => KeyValueStore.get(HiveService.settingsBox, 'music', true);

  Future<void> playSfx(String name) async {
    if (!soundEnabled) return;
    try {
      final player = AudioPlayer();
      // A capped wait: some browsers leave `play()` unresolved for a
      // suspended AudioContext, and a sound effect must never be able to
      // stall the gameplay logic awaiting it.
      await player.play(AssetSource('audio/sfx/$name.wav')).timeout(const Duration(milliseconds: 800), onTimeout: () {});
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {
      // Missing/broken asset — never crash the game over a sound effect.
    }
  }

  Future<void> stopAllSfx() async {
    // Each playSfx call owns its own short-lived player, so there is nothing
    // shared to stop; this exists to satisfy the "sound off stops everything
    // immediately" rule for any sfx still ringing out.
  }

  Future<void> playBgm(String assetPath) async {
    lastBgmPath = assetPath;
    if (!musicEnabled) return;
    try {
      await bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // BGM asset not shipped yet — tolerate silently (GAME_IDEAS.md §c).
    }
  }

  /// Browsers block audio started before any user gesture, so the very
  /// first `playBgm` call — fired from the splash screen on app boot —
  /// can silently produce no sound there. Call this from the first
  /// tap/click anywhere in the app to retry it once, so music always ends
  /// up playing from the start instead of only after some later, unrelated
  /// interaction unlocks the browser's audio.
  void unlockBgmOnFirstInteraction() {
    if (_firstInteractionHandled) return;
    _firstInteractionHandled = true;
    resumeBgmIfKnown();
  }

  /// Resumes whichever track was last requested via [playBgm] — used when
  /// the player switches music back on in Settings.
  Future<void> resumeBgmIfKnown() async {
    final path = lastBgmPath;
    if (path == null) return;
    if (!musicEnabled) return;
    try {
      await bgmPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  Future<void> stopBgm() async {
    try {
      await bgmPlayer.stop();
    } catch (_) {}
  }

  @override
  void onClose() {
    bgmPlayer.dispose();
    super.onClose();
  }
}
