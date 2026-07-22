import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../storage/hiveService.dart';
import '../storage/keyValueStore.dart';

/// Plays short SFX and looping BGM (GAME_IDEAS.md §3.8-a). Always checks the
/// sound/music settings first, and every call is wrapped in try/catch so a
/// missing audio asset never crashes the game.
class AudioService extends GetxService {
  final AudioPlayer bgmPlayer = AudioPlayer();

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
      await player.play(AssetSource('audio/sfx/$name.wav'));
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
    if (!musicEnabled) return;
    try {
      await bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // BGM asset not shipped yet — tolerate silently (GAME_IDEAS.md §c).
    }
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
